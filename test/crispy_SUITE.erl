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
%%--------------------------------------------------------------------
%% COMMON TEST CALLBACK FUNCTIONS
%%--------------------------------------------------------------------
suite() ->
  [{timetrap, {minutes, 10}}].

init_per_suite(Config) ->
  inets:start(),
  application:ensure_all_started(?APP_NAME),
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
  [].

all() ->
  [test_get_all].
%%--------------------------------------------------------------------
%% COMMON TEST CASES
%%--------------------------------------------------------------------
test_get_all(Config) ->
  Result = ?perform_get(?URL),
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