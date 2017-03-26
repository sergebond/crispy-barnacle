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

get(all) -> get(all, list).
get(What, Format) when Format =:= list; Format =:= json ->
  Res =
    case What of
      all -> ets:select(?TABLE_CONTACTS, [{'$1',[],['$1']}]);
      Id when is_integer(Id) -> ets:lookup(?TABLE_CONTACTS, Id)
    end,
  convert_rec_to(Format, Res).

create(Contact) ->
  ets:insert(?TABLE_CONTACTS, Contact).



update(Contact) ->
  ets:insert(?TABLE_CONTACTS, Contact).

delete(Id) ->
  ets:delete(?TABLE_CONTACTS, Id).

%% Convert
convert_rec_to(list, Contact) when is_record(Contact, 'contact') ->
  lists:zip(record_info(fields, 'contact'), tl(tuple_to_list(Contact)));
convert_rec_to(list, Contacts) when is_list(Contacts) ->
  lists:map(fun(Contact) -> convert_rec_to(list, Contact) end, Contacts).