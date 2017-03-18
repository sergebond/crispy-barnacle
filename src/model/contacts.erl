-module(contacts).
-author("srg").
-include("crispy.hrl").

%% API
-export([
  get/0,
  create/1,
  update/1,
  delete/1
]).

init() ->
  ok = counter:create(id),
  ok = ets:new(?TABLE_CONTACTS, [set, named_table, {keypos,2}]).

get(Id) -> ok.
create(Contact) -> ok.
update(Contact) -> ok.
delete(Contact) -> ok.

