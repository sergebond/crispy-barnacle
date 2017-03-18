-author("srg").

-define(APP_NAME, crispy).
-define(TABLE_CONTACTS, contacts).
-define(COUNTER_NAME, id).

-record(contact, {
  id = counter:next(?COUNTER_NAME) :: integer(),
  name :: binary(),
  surname :: binary(),
  phone :: binary(),
  description :: binary()
}).