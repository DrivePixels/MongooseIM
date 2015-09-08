
# MongooseIM 1.5.1

2015-04-02

This release includes:

- fix for BOSH inactivity timeout ([#341](https://github.com/esl/MongooseIM/pull/341))
- improved compatibility with Stanza.io - including also fix for stream management ([#347](https://github.com/esl/MongooseIM/pull/347))
- removed dead code ([#328](https://github.com/esl/MongooseIM/pull/328), [#335](https://github.com/esl/MongooseIM/pull/335), [#336](https://github.com/esl/MongooseIM/pull/336), [#339](https://github.com/esl/MongooseIM/pull/339))
- unified roster logic ([#359](https://github.com/esl/MongooseIM/pull/359))
- rearranged documentation ([#363](https://github.com/esl/MongooseIM/pull/363), [#368](https://github.com/esl/MongooseIM/pull/368))
- other small improvements ([#337](https://github.com/esl/MongooseIM/pull/337), [#338](https://github.com/esl/MongooseIM/pull/338), [#345](https://github.com/esl/MongooseIM/pull/345), [#349](https://github.com/esl/MongooseIM/pull/349), [#350](https://github.com/esl/MongooseIM/pull/350), [#353](https://github.com/esl/MongooseIM/pull/353), [#364](https://github.com/esl/MongooseIM/pull/364), [#366](https://github.com/esl/MongooseIM/pull/366))
- [complete list of merged PRs](https://github.com/esl/MongooseIM/pulls?utf8=%E2%9C%93&q=is%3Apr+is%3Amerged+merged%3A%222014-12-01+..+2015-02-14%22)
- [complete list of closed issues](https://github.com/esl/MongooseIM/issues?utf8=%E2%9C%93&q=is%3Aclosed+is%3Aissue+created%3A%222014-12-01+..+2015-02-14%22+)


# MongooseIM 1.5.0

2014-12-02

This release:

- adds support for [XEP-0079: Advanced Message Processing](http://xmpp.org/extensions/xep-0079.html) - [#252](https://github.com/esl/MongooseIM/pull/252), [#314](https://github.com/esl/MongooseIM/pull/314)
- adds support for [XEP-0280: Message Carbons](http://xmpp.org/extensions/xep-0280.html) - [#264](https://github.com/esl/MongooseIM/pull/264)
- adds pluggable authentication module via HTTP - [#274](https://github.com/esl/MongooseIM/pull/274) ([documentation on wiki](https://github.com/esl/MongooseIM/wiki/HTTP-authentication-module))
- enables run time configuration reload - [#296](https://github.com/esl/MongooseIM/pull/296)
- includes security improvement - [#300](https://github.com/esl/MongooseIM/pull/300), [#304](https://github.com/esl/MongooseIM/pull/304)
- fixes ODBC layer support - [#275](https://github.com/esl/MongooseIM/pull/275)
- adds commands for clustering - [#228](https://github.com/esl/MongooseIM/pull/228)
- adds Cassandra backend for [XEP-0313: Message Archive Management](http://xmpp.org/extensions/xep-0313.html) - [#151](https://github.com/esl/MongooseIM/pull/151)
- other improvements and fixes
  - complete list of [merged pull requests](https://github.com/esl/MongooseIM/pulls?q=is%3Apr+is%3Amerged+merged%3A%3E2014-05-20+created%3A%3C2014-12-01)
  - complete list of [closed issues](https://github.com/esl/MongooseIM/issues?q=is%3Aclosed+is%3Aissue+closed%3A%3E2014-05-20++created%3A%3C2014-12-01)


# MongooseIM 1.4.0

2014-05-20

- adds support for Stream Management [XEP-0198](http://xmpp.org/extensions/xep-0198.html) - [#195](https://github.com/esl/MongooseIM/pull/195)
- adds support for new [XMPP over WebSocket](http://tools.ietf.org/html/draft-ietf-xmpp-websocket-06) - [#173](https://github.com/esl/MongooseIM/pull/173)
- adds support for SCRAM-SHA-1 authentication both for ODBC and mnesia user backends - [#171](https://github.com/esl/MongooseIM/pull/171)

> !! requires `users` table schema update for MySQL and PostgreSQL: [68b790c](https://github.com/esl/MongooseIM/commit/68b790c6b64bed7894602d003b94ef1037059e55) !!

- improves security [#196](https://github.com/esl/MongooseIM/pull/196):
  - support for DH and ECDH key exchange protocol
  - configurable list of allowed cipher suites
- uses [travis-ci.org](https://travis-ci.org/esl/MongooseIM) with our [test suite](https://github.com/esl/ejabberd_tests)
- fixes privacy lists removal after user deletion - [#186](https://github.com/esl/MongooseIM/pull/186)
- fixes roster versioning issue [#199](https://github.com/esl/MongooseIM/pull/199)
- fixes multi-invite bug in MUC - [#180](https://github.com/esl/MongooseIM/pull/180)
- other code improvements and small fixes


# MongooseIM 1.3.2

2014-04-15

- fix for [Uncontrolled Resource Consumption with XMPP-Layer Compression](http://xmpp.org/resources/security-notices/uncontrolled-resource-consumption-with-highly-compressed-xmpp-stanzas/)

zlib driver configuration (in c2s or s2s section) takes new parameter which is max size of decompressed data

- unified logic for modules (use option `backend` in module config section with possible values `mnesia` (default) or `odbc`):

  - mod_privacy
  - mod_private
  - mod_offline
- `max_connections` parameter for `ejabberd_cowboy` listener
- improved BOSH implementation
- improved vCard search mechanism
- other small fixes/improvements

# MongooseIM 1.3.1

2014-02-21

- port XEP-0114 (ejabberd_service)
- port LDAP vCard support
- port LDAP Shared Roster support
- finalize project rename to MongooseIM by changing scripts names

# MongooseIM 1.3.0

2014-01-28

- added [XEP-0313: Message Archive Management](http://xmpp.org/extensions/xep-0313.html) support (`mod_mam`)
- port LDAP authentication from ejabberd
- added PostgreSQL support
- disable SSL 2.0 support
- disable old unsafe ciphers
- make the repo includable as a rebar dependency
- use `#xmlel{}` instead of `{xmlel, ...}` in the whole codebase

# MongooseIM 1.2.2

2013-05-23

* use upstream lager
* added CHANGELOG file
* replace exml tuples with record
* don't use binaries in ejabberd.cfg
* add support for alarms #82


# MongooseIM 1.2.1

2013-05-15

* Folsom metrics improvements
* REST interface for accessing metrics
* BOSH fixes
* Don't allow session to hang forever after pause


# MongooseIM 1.2.0

2013-05-12

- BOSH support (XMPP over HTTP) 
- WSS (WebSocekt Secure) 
- various XMPP related metrics exposed via REST API
  (https://github.com/esl/ejabberd/wiki/REST-interface-to-folsom-metrics) 
- alarm handler for better monitoring and bottleneck finding 

We've also assured compatibility with the latest ejabberd Community Edition by
ProcessOne, so that backporting ejabberd modules to MongooseIM requires
less effort.


# MongooseIM 1.1.0

2012-12-04

- list to binary conversion
- Multi-User Chat (MUC) fixes and cleanups
- style and indentation fixes
- change logger to lager


# MongooseIM 1.0.0

2012-07-10

- remove tsung from source tree
- add ejabberdctl with admin and admin_extra commands
- add devrel target
- binarise remaining modules
- fix p1_fsm get_status handler


# MongooseIM 0.9.0

2012-05-21

* add makefile target that downloads rebar
* re-added mod_offline & mod_last_odbc & mod_sic
* continue transition to binaries instead of strings and remove no ported modules:
    * ejabberd_http
    * ejabberd_http_bind
    * ejabberd_http_poll
    * mod_http_bind
    * mod_adhoc
    * mod_announce
    * mod_blocking
    * mod_configure
    * mod_configure2
    * mod_disco
    * mod_echo
    * mod_http_fileserver
    * mod_last
    * mod_muc,
    * mod_muc_log
    * mod_offline_odbc
    * mod_ping
    * mod_pres_counter
    * mod_privacy_odbc
    * mod_private
    * mod_proxy65
    * mod_pubsub
    * mod_register_web
    * mod_roster_odbc
    * mod_service
    * mod_shared_roster
    * mod_shared_roster_ldap
    * mod_stats
    * mod_timea
    * mod_vcard
    * mod_vcard_odbc
    * mod_vcard_xupdate
    * mod_version


# MongooseIM 0.1.0-pre

2012-04-17

* rebarify
* add escalus tests
* binarise core modules
* dialyzer support
* change table copy type of acl, config, local_config to ram_copies