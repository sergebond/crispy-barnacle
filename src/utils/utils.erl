-module(utils).
-author("serg").

%% API
-export([
  to_json/1,
  from_json/1,
  get_value/2,
  get_value/3,
  get_unixtime/0]).

%%----------------------------------------------------------------------
%%                        JSON ENCODE/DECODE
%%----------------------------------------------------------------------

% Term to json convertor -> binary()
to_json({ok, Data}) when is_binary(Data)->
  Data;
to_json(Data) when is_binary(Data)->
  Data;


% jsx
to_json(Data)->
  to_json_run(jiffy, Data).

% jiffy
to_json_run(jiffy, Data)->
  NewData = jiffy_encode_params(Data),
  try jiffy:encode( NewData ) of
    JSON    -> JSON
  catch _E:_Desc ->
    lager:error("[JSON] Error jiffy:encode ~p~n~p", [ NewData, erlang:get_stacktrace() ]) ,
    <<"error json encode">>
  end.

from_json( Text ) -> from_json( Text, <<"error_json_decode">> ).
from_json(Text, Default)->
  from_json_run(jiffy, Text, Default).


% jiffy
from_json_run(jiffy, null, Default)->
  Default;

from_json_run(jiffy, Text, Default)->
  try jiffy:decode( Text ) of
    Data  ->
      jiffy_decode_params(Data)
  catch _E:_Desc  ->
    lager:error("[JSON] Error jiffy:decode ~p ~n~p", [ Text, erlang:get_stacktrace() ]),
    Default
  end.

% encode
jiffy_encode_params(List = [{_, _} | _]) when is_list(List)->
  Res =
    lists:map(fun(Value) ->
      case Value of
        {Key, Val} -> {Key, jiffy_encode_param(Val)};
        _          -> jiffy_encode_params(Value)
      end
              end, List),
  {Res};

jiffy_encode_params(List) when is_list(List)->
  lists:map(fun(Value)-> jiffy_encode_params(Value) end, List);

jiffy_encode_params(Params)-> Params.


% [{},{},{}]
jiffy_encode_param(Val = [{_, _} | _])->
  jiffy_encode_params(Val);

% [[{},{},{}],[{},{},{}],[{},{},{}]]
jiffy_encode_param(Val) when is_list(Val)->
  lists:map(fun(Value)-> jiffy_encode_params(Value) end, Val);

jiffy_encode_param(Val)->
  Val.

% decode
jiffy_decode_params({List = [{_, _} | _]}) when is_list(List)->
  lists:map(fun(Value)->
    case Value of
      {Key, Val} -> {Key, jiffy_decode_param(Val)};
      _          -> jiffy_decode_params(Value)
    end
            end, List);

jiffy_decode_params(List) when is_list(List)->
  lists:map(fun(Value)-> jiffy_decode_params(Value) end, List);

jiffy_decode_params(Params)->
  Params.

% [{},{},{}]
jiffy_decode_param({Val = [{_, _} | _]})->
  jiffy_decode_params({Val});

% [[{},{},{}],[{},{},{}],[{},{},{}]]
jiffy_decode_param(Val) when is_list(Val)->
  lists:map(fun(Value)-> jiffy_decode_params(Value) end, Val);

jiffy_decode_param(Val)->
  Val.

%%----------------------------------------------------------------------
%%                       MISCELANEOUS
%%----------------------------------------------------------------------
-spec get_unixtime() -> integer(). %% now in sec
get_unixtime() ->
  {Mega, Secs, _Micro} = os:timestamp(),
  Timestamp = Mega * 1000000 + Secs,
  Timestamp.

-spec get_value(term(), list()) -> undefined|term().
get_value(Key, List) ->
  get_value(Key, List, undefined).
get_value(Key, List, Default)->
  case lists:keyfind(Key, 1, List) of
    {_, Val} -> Val;
    _ -> Default
  end.