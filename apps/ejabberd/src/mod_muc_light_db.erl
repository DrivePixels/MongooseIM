%%%----------------------------------------------------------------------
%%% File    : mod_muc_light_db.erl
%%% Author  : Piotr Nosek <piotr.nosek@erlang-solutions.com>
%%% Purpose : MUC light DB behaviour
%%% Created : 6 Oct 2015 by Piotr Nosek <piotr.nosek@erlang-solutions.com>
%%%----------------------------------------------------------------------

-module(mod_muc_light_db).
-author('piotr.nosek@erlang-solutions.com').

-include("mod_muc_light.hrl").

-type modify_aff_users_return() :: {ok, OldAffUsers :: aff_users(), NewAffUsers :: aff_users(),
                                    AffUsersChanged :: aff_users(), PrevVersion :: binary()}
                                 | {error, any()}.

-type remove_user_return() :: [{RoomUS :: ejabberd:simple_bare_jid(),
                                modify_aff_users_return()}]. 

-export_type([modify_aff_users_return/0, remove_user_return/0]).

%%====================================================================
%% Behaviour callbacks
%%====================================================================

%% ------------------------ Backend start/stop ------------------------

-callback start(Host :: ejabberd:server(), MUCHost :: ejabberd:server()) -> ok.

-callback stop(Host :: ejabberd:server(), MUCHost :: ejabberd:server()) -> ok.

%% ------------------------ General room management ------------------------

-callback create_room(RoomUS :: ejabberd:simple_bare_jid(), Config :: config(),
                      AffUsers :: aff_users(), Version :: binary()) ->
    {ok, FinalRoomUS :: ejabberd:simple_bare_jid()} | {error, exists}.

-callback destroy_room(RoomUS :: ejabberd:simple_bare_jid()) -> ok | {error, not_exists}.

-callback room_exists(RoomUS :: ejabberd:simple_bare_jid()) -> boolean().

-callback get_user_rooms(UserUS :: ejabberd:simple_bare_jid()) ->
    {ok, [RoomUS :: ejabberd:simple_bare_jid()]} | {error, term()}.

-callback remove_user(UserUS :: ejabberd:simple_bare_jid(), Version :: binary()) ->
    remove_user_return() | {error, term()}.

%% ------------------------ Configuration manipulation ------------------------

-callback get_config(RoomUS :: ejabberd:simple_bare_jid()) ->
    {ok, config(), Version :: binary()} | {error, not_exists}.

-callback get_config(RoomUS :: ejabberd:simple_bare_jid(), Key :: atom()) ->
    {ok, term(), Version :: binary()} | {error, not_exists | invalid_opt}.

-callback set_config(RoomUS :: ejabberd:simple_bare_jid(), Config :: config(),
                     Version :: binary()) -> {ok, PrevVersion :: binary()} | {error, not_exists}.

-callback set_config(RoomUS :: ejabberd:simple_bare_jid(), Key :: atom(),
                     Val :: term(), Version :: binary()) ->
    {ok, PrevVersion :: binary()} | {error, not_exists}.

%% ------------------------ Blocking manipulation ------------------------

-callback get_blocking(UserUS :: ejabberd:simple_bare_jid()) -> [blocking_item()].

-callback get_blocking(UserUS :: ejabberd:simple_bare_jid(),
                       WhatWhos :: [{blocking_who(), ejabberd:simple_bare_jid()}]) ->
    blocking_action().

-callback set_blocking(UserUS :: ejabberd:simple_bare_jid(),
                       BlockingItems :: [blocking_item()]) -> ok.

%% ------------------------ Affiliations manipulation ------------------------

-callback get_aff_users(RoomUS :: ejabberd:simple_bare_jid()) ->
    {ok, aff_users(), Version :: binary()} | {error, not_exists}.

-callback modify_aff_users(RoomUS :: ejabberd:simple_bare_jid(),
                           AffUsersChanges :: aff_users(),
                           ExternalCheck :: external_check_fun(),
                           Version :: binary()) ->
    modify_aff_users_return().

%% ------------------------ Getting room configuration ------------------------

-callback get_info(RoomUS :: ejabberd:simple_bare_jid()) ->
    {ok, config(), aff_users(), Version :: binary()} | {error, not_exists}.

%% ------------------------ API for tests ------------------------

-callback force_clear() -> ok.
