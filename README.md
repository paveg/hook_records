hook records
===

[![CircleCI](https://circleci.com/gh/paveg/hook_records.svg?style=svg&circle-token=d230f43d9593dda2c05e68ac6a7f06bdb9d3b0bd)][circleci]
[![codecov](https://codecov.io/gh/paveg/hook_records/branch/master/graph/badge.svg)][codecov]
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][license]

[circleci]: https://circleci.com/gh/paveg/hook_records
[codecov]: https://codecov.io/gh/paveg/hook_records
[license]: https://github.com/paveg/hook_records/blob/master/LICENSE

* Requirements Ruby version
  * 2.5.1

* Configuration

  * mysql
```:my.cnf
# default homebrew mysql server config
[mysqld]
# only allow connections from localhost
bind-address = 127.0.0.1

character-set-server = utf8mb4

innodb-file-format = barracuda
innodb_file_per_table = true
innodb-large-prefix = true

[client]
default-character-set = utf8mb4
```

* Database creation

```
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

* Database initialization

```
$ bundle exec rake db:build
```

* How to run the test suite

```
$ cd path/to/app
$ bundle exec rspec ./spec
```

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
