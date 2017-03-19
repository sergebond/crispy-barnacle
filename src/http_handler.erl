-module(http_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {
}).

init(_, Req, _Opts) ->
  {ok, Req, #state{}}.

handle(Req, State=#state{}) ->
  {PathInfo, Req1} = cowboy_req:path_info(Req),
  {Method, Req2} = cowboy_req:method(Req1),
  {ok, Body, Req3} = cowboy_req:body(Req2),
  {Code, Response} =
    try handle_command(Method, PathInfo, utils:from_json(Body)) of
      {ok, Resp} when is_list(Resp) ->
        {200, Resp}
    catch
      {error, Reas} ->
        {500, Reas};
      SomethingElse -> lager:error("Error ~p" , [SomethingElse])
    end,
  {ok, Req4} = cowboy_req:reply(Code, [], utils:to_json(Response), Req3),
  {ok, Req4, State}.

terminate(_Reason, _Req, _State) ->
  ok.

handle_command(<<"GET">>, _PathInfo, Data) ->
  lager:info("Data has come"),
  {ok, []};
handle_command(<<"POST">>, _PathInfo, Data) ->
  {ok, []};
handle_command(<<"PUT">>, _PathInfo, Data) ->
  {ok, []};
handle_command(<<"DELETE">>, _PathInfo, _Body) ->
  {ok, []};

handle_command(_Method, _PathInfo, _Body) ->
  {error, <<"Unknown method">>}.