### Module Description

This module implements handling of tokens in oAuth-like authentication scheme. It provides necessary services to:

* deserialize/serialize binary tokens received and issued by server,
* validate incoming binary tokens, i.e.:
    * check integrity using Message Authentication Codes (MAC) with use of server-side stored user keys,
    * check validity against configured validity duration times,
    * check revocation status,
* handle token requests from logged in users.

The module itself does not implement protocol related details - these are implemented in `cyrsasl.erl`.
Generation of keys necessary to sign binary tokens is delegated to module `mod_keystore.erl`.

### Configuration

#### Validity periods

Access and refresh tokens validity periods can be defined independently.

Allowed units are:

* days
* hours
* minutes
* seconds

unless defined, the default values for tokens are:

* 1 hour for access token
* 25 days for refresh token

Example configuration from `ejabberd.cfg` - inside `modules` section:

```erlang
{modules, [
    {mod_auth_token, [{{validity_period, access}, {13, minutes}},
                      {{validity_period, refresh}, {13, days}}]
]}.
```

Validity period configuration for provision tokens is outside the module scope
since the server does not generate provision tokens - it only validates them.

#### Required keys

Keys are used for signing binary tokens using an HMAC with SHA-2 family function SHA-384.
Therefore, `mod_auth_token` requires `mod_keystore` to provide some predefined keys.

The required keys are (example from `ejabberd.cfg`):

```erlang
{mod_keystore, [{keys, [{token_secret, ram},
                        {provision_pre_shared, {file, "priv/provision_pre_shared.key"}}]}]}
```

`token_secret` is a RAM-only (i.e. generated on cluster startup, never written to disk)
key used for signing and verifying access and refresh tokens.

`provision_pre_shared` is a key read from file.
As its name suggests, it's a key shared with a service issuing provision tokens.
Clients then use these provision tokens to authenticate with MongooseIM.

While it's not enforced by the server and left completely to the operator,
`provision_pre_shared` keys probably should not be shared between virtual
XMPP domains hosted by the server.
That is, make sure module configuration specifying a `provision_pre_shared` key
is specific to an XMPP domain.

MongooseIM can't generate provision tokens on its own (neither can it distribute them to clients),
so while configuring a `provision_pre_shared` key to be RAM-only is technically possible,
it would in practice disable provision token support
(as no external service could generate a valid token with this particular RAM key).

### Token serialization format

All tokens (access / refresh / provision) are to be exchanged as *Base64 encoded* binary data.
Serialization format of the token before encoding with Base64 is dependent on its type:

```
'access' \0 <BARE_JID> \0 <EXPIRES_AT> \0 <MAC>

'refresh' \0 <BARE_JID> \0 <EXPIRES_AT> \0 <SEQUENCE_NO> \0 <MAC>

'provision' \0 <BARE_JID> \0 <EXPIRES_AT> \0 <VCARD> \0 <MAC>
```

For example (these tokens are randomly generated,
hence field values don't make much sense,
line breaks are inserted only for the sake of formatting,
`<vCard/>` inner HTML is snipped):

```
'access' \0 Q8@localhost \0 64875466454
    \0 0acd0a66d06934791d046060cf9f1ad3c2abb3274cc7e7d7b2bc7e2ac4453ed774b6c6813b40ebec2bbc3774d59d4087

'refresh' \0 qp@localhost \0 64875466457 \0 6
    \0 8f57cb019cd6dc6e7779be165b9558611baf71ee4a40d03e77b78b069f482f96c9d23b1ac1ef69f64c1a1db3d36a96ad

'provision' \0 Xmi4@localhost \0 64875466458 \0 <vCard>...</vCard>
    \0 86cd344c98b345390c1961e12cd4005659b4b0b3c7ec475bde9acc9d47eec27e8ddc67003696af582747fb52e578a715
```

### Requesting access / refresh tokens when logged in

```xml
<iq type='get' to='john@localhost' id='123'>
    <query xmlns='erlang-solutions.com:xmpp:token-auth:0'/>
</iq>
```

To request access and refresh tokens for the first time a client should
send an IQ stanza - after he has successfully authenticated
for the first time using some other method.

### Token response format

Requested tokens are being returned by server wrapped in IQ stanza with the following fields:

- `from` (bare user JID)
- `to` (full user JID)
- `id` (value taken from request IQ stanza)
- `type` (result)

Example response (encoded tokens have been truncated in this example):

```xml
<iq type='result' to='john@localhost/res1' id='123' from='john@localhost'>
    <items xmlns='erlang-solutions.com:xmpp:token-auth:0'>
        <access_token>cmVmcmVzaAGQ1Mzk1MmZlYzhkYjhlOTQzM2UxMw==</access_token>
        <refresh_token>cmVmcmVzaAGQ1Mzk1MmZlYzhkYjhlOTQzM2UxMw==</refresh_token>
    </items>
</iq>
```

Once a client has obtained a token (s)he may start authenticating
using the `X-OAUTH` SASL mechanism when reaching the authentication
phase of an XMPP connection initiation.

### Login with access/refresh token

In order to log into the XMPP server using a previously requested token
a client should send the following stanza:

```xml
<auth xmlns="urn:ietf:params:xml:ns:xmpp-sasl" mechanism="X-OAUTH">
cmVmcmVzaAGQ1Mzk1MmZlYzhkYjhlOTQzM2UxMw== 
</auth>
```

The Base64 encoded content is a token obtained prior to authentication.
Authentication will succeed unless the used tokens are expired, revoked,
or the keys required for MAC verification could not be found by the server.

**When using a refresh token to authenticate with the server**,
the server will respond with a new *access token*:

```xml
<success xmlns="urn:ietf:params:xml:ns:xmpp-sasl">
cmVmcmVzaAGQ1Mzk1MmZlYzhkYjhlOTQzM2UxMw==
</success>
```

The above response is to be expected unless the refresh token used is expired
or there were some problems processing the key on the server side.

### Token revocation using command line tool

Refresh tokens issued by the server can be used to:

* log in a user - as an authentication valet,
* request *a new access token* with refreshed expiry date.

An administrator may *revoke* a refresh token:

```sh
mongooseimctl revoke_token owner@xmpphost
```

A client can no longer use a revoked token either for authentication
or requesting new access tokens.
After a client's token has been revoked in order to obtain a new refresh token
a client has to log in using some other method.

**Caveat:** as of now, the user's session is not terminated automatically on token revocation.
Therefore, the user might request a new set of tokens for as long as the session is active,
even though his/her previous token was just revoked (possibly due to a breach / token leak).
Moreover, an access token still kept on a compromised device can be used
to establish a new session for as long as it's valid - access tokens can't be revoked.
To alleviate rerequesting tokens by the user an operator can use
`mod_admin` extension allowing to terminate the user's connection.
Access token validity can't be sidestepped right now.