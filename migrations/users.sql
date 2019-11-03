-- 1 up
create table if not exists users (
  id    integer primary key autoincrement,
  email text,
  token  text
);

-- 1 down
drop table if exists posts;
