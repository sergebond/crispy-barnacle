-module(crispy_app).
-behaviour(application).
-include("crispy.hrl").

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
%%  ok = application:ensure_started(lager),
  ok = contacts:init(),

  Dispatch = cowboy_router:compile([
    {'_', [
      {"/", http_handler, []},
      {"/static/[...]", cowboy_static, {priv_dir, ?APP_NAME, "",
        [{mimetypes, cow_mimetypes, all}]}}
    ]}
  ]),

  {ok, _} = cowboy:start_http(http, 100, [{port, 8080}], [
    {env, [{dispatch, Dispatch}]}
  ]),

  io:format("_____________Handlers started"),

  crispy_sup:start_link().

stop(_State) ->
  ok.
