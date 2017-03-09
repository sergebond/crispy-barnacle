-author("srg").

-define(APP_NAME, crispy).
-define(TABLE_CONTACTS, contacts).

-record(contact, {
  id,
  name,
  surname,
  phone,
  description
}).