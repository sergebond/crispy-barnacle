-module(crispy_app).
-behaviour(application).
-include("crispy.hrl").

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
  contacts:init(),
  Dispatch = cowboy_router:compile([
    {'_', [
      {"/", cowboy_static, {priv_file, ?APP_NAME, "index.html"}},
      {"/static/[...]", cowboy_static, {priv_dir, ?APP_NAME, "",
        [{mimetypes, cow_mimetypes, all}]}}
    ]}
  ]),

  {ok, _} = cowboy:start_http(http, 100, [{port, 8080}], [
    {env, [{dispatch, Dispatch}]}
  ]),

  lager:info("Handlers started"),

  crispy_sup:start_link().

stop(_State) ->
  ok.
