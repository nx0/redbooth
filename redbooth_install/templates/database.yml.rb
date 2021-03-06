default: &default
  adapter: mysql
  encoding: utf8
  username: root
  password: <%= PWD_MYSQL =>
  host: 127.0.0.1
  port: 3306

development:
  <<: *default
  database: db_dev

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: db_test

production:
  <<: *default
  database: db_prod
