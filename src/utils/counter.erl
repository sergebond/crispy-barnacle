-module(counter).
-author("serg").
-define(COUNTERS_TABLE, counters_table).
%% API
-export([create/1, get/1, set/2, next/1, prev/1, update/2]).

-spec create(CounterName :: term() ) -> ok.
create(CounterName) ->
  set(CounterName, 0).

get(CounterName) ->
  update(CounterName, 0).

next(CounterName) ->
  update(CounterName, 1).

prev(CounterName) ->
  update(CounterName, -1).

set(CounterName, Value) when is_integer(Value) ->
  case ets:info(?COUNTERS_TABLE) of
    undefined ->
      ?COUNTERS_TABLE = ets:new(?COUNTERS_TABLE, [set, named_table, public]),
      io:format("Ets inited");
    _ -> ok
  end,
  true = ets:insert(?COUNTERS_TABLE, {CounterName, Value}),
  Value.

%% ----------------------------------PRIVATE
-spec update(CounterName :: term(), integer()) ->  Value :: integer()|{error, Reason :: binary()}.
update(CounterName, ByVal) ->
  try ets:update_counter(?COUNTERS_TABLE, CounterName, {2, ByVal}) of
    Count -> Count
  catch
    _:_ -> {error, "Unknown counter"}
  end.