-module(contacts).
-author("srg").
-include("crispy.hrl").

%% API
-export([
  get/0,
  edit/1,
  delete/1,
  insert/1
]).

init() ->
  ok = ets:new(?TABLE_CONTACTS, [set, named_table, {keypos,2}]).

get() -> ok.
edit(Contact) -> ok.
delete(Contact) -> ok.
insert(Contact) -> ok.
