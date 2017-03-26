-module(crispy_SUITE).
-author("serg").

-compile(export_all).

-include_lib("common_test/include/ct.hrl").
% etest macros
-include_lib ("etest/include/etest.hrl").
% etest_http macros
-include_lib ("etest_http/include/etest_http.hrl").

-include("crispy.hrl").

-define(URL, "http://127.0.0.1:8080").
-define(COUNTER, q1).

%%--------------------------------------------------------------------
%% COMMON TEST CALLBACK FUNCTIONS
%%--------------------------------------------------------------------
suite() ->
  [{timetrap, {minutes, 10}}].

init_per_suite(Config) ->
  ok = inets:start(),
  {ok, _Apps} = application:ensure_all_started(?APP_NAME),
%%  ct:pal("Response ~p", [Term]),
  Config.

end_per_suite(_Config) ->
  ok.

init_per_group(_GroupName, Config) ->
  Config.

end_per_group(_GroupName, _Config) ->
  ok.

init_per_testcase(_TestCase, Config) ->
  Config.

end_per_testcase(_TestCase, _Config) ->
  ok.

groups() ->
  [
    {general,
      [sequence], [
      test_counter
    ]},
    {http,
      [sequence], [
      test_get_all
%%      test_get,
%%      test_create,
%%      test_update,
%%      test_delete
      ]}
  ].

all() ->
  [
    {group, general},
    {group, http}
  ].
%%--------------------------------------------------------------------
%% COMMON TEST CASES
%%--------------------------------------------------------------------
test_get_all(Config) ->
  Result = #etest_http_res{body = Body, status = Status} = ?perform_get(?URL),
  ct:pal("Body is ~p~nStatus is ~p", [Body, Status]),
  ?assert_status(200, Result),
  Config.

test_get(Config) ->
  Result = ?perform_get(?URL),
  ?assert_status(200, Result),
  Config.

test_create(Config) ->
  Config.
test_update(Config) ->
  Config.
test_delete(Config) ->
  Config.

test_counter(Config) ->
  ?assert_equal(counter:create(?COUNTER),0),
  ?assert_equal(counter:get(?COUNTER), 0),
  ?assert_equal(counter:next(?COUNTER), 1),
  ?assert_equal(counter:next(?COUNTER), 2),
  ?assert_equal(counter:prev(?COUNTER), 1),
  ?assert_equal(counter:get(?COUNTER), 1),
  ?assert_equal(counter:update(?COUNTER, 10), 11),
  ?assert_equal(counter:get(?COUNTER), 11),
  ?assert_equal(counter:set(?COUNTER, 9999), 9999),
  ?assert_equal(counter:get(?COUNTER), 9999),
  ct:pal("test_counter is ok"),
  Config.