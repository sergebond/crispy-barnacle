-module(contacts).
-author("srg").
-include("crispy.hrl").

%% API
-export([
  init/0,
  get/1,
  create/1,
  update/1,
  delete/1
]).

init() ->
  0 = counter:create(id),
  ?TABLE_CONTACTS = ets:new(?TABLE_CONTACTS, [set, named_table]),
  ok.

get(all) ->
  ets:select(?TABLE_CONTACTS, [{'$1',[],['$1']}]);
get(Id) ->
  ets:lookup(?TABLE_CONTACTS, Id).

create(Contact) ->
  ets:insert(?TABLE_CONTACTS, Contact).

update(Contact) ->
  ets:insert(?TABLE_CONTACTS, Contact).

delete(Id) ->
  ets:delete(?TABLE_CONTACTS, Id).