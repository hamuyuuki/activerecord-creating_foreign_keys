[![Build Status](https://travis-ci.com/hamuyuuki/activerecord-creating_foreign_keys.svg?branch=master)](https://travis-ci.com/hamuyuuki/activerecord-creating_foreign_keys)
[![Maintainability](https://api.codeclimate.com/v1/badges/3cac3284bb083ea1f9cd/maintainability)](https://codeclimate.com/github/hamuyuuki/activerecord-creating_foreign_keys/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/3cac3284bb083ea1f9cd/test_coverage)](https://codeclimate.com/github/hamuyuuki/activerecord-creating_foreign_keys/test_coverage)

# activerecord-creating_foreign_keys
`activerecord-creating_foreign_keys` defines FOREIGN KEY Constraints in a CREATE TABLE Statement.

Rails 4.2 [supports adding and removing foreign keys](https://guides.rubyonrails.org/v4.2/4_2_release_notes.html#foreign-key-support). And Rails 4.2.1 [supports adding a `:foreign_key` option to `references`](https://github.com/rails/rails/blob/4-2-stable/activerecord/CHANGELOG.md#rails-421-march-19-2015).
But it defines FOREIGN KEY Constraints in a ALTER TABLE Statement as an additional DDL when you define a `:foreign_key` option to `references`.

Rails 5 [supports defining FOREIGN KEY Constraints in a CREATE TABLE Statement](https://github.com/rails/rails/pull/20009/files). So `activerecord-creating_foreign_keys` backports that into Rails 4.2.

## Getting Started
Install `activerecord-creating_foreign_keys` at the command prompt:
```sh
gem install activerecord-creating_foreign_keys
```

Or add `activerecord-creating_foreign_keys` to your Gemfile:
```ruby
gem "activerecord-creating_foreign_keys"
```

## How to use
You don't need to do anything after installing `activerecord-creating_foreign_keys`.

You can know **Before** and **After** if `testings` is created.

```
create_table :testings do |t|
  t.references :testing_parent, foreign_key: true
end
```

**Before**
```sql
CREATE TABLE "testings" ("id" serial primary key, "testing_parent_id" integer);
ALTER TABLE "testings" ADD CONSTRAINT "fk_rails_a196c353b2" FOREIGN KEY ("testing_parent_id") REFERENCES "testing_parents" ("id");
```

**After**
```sql
CREATE TABLE "testings" ("id" serial primary key, "testing_parent_id" integer, CONSTRAINT "fk_rails_a196c353b2" FOREIGN KEY ("testing_parent_id") REFERENCES "testing_parents" ("id"));
```

## Limitation
At this time, only the `mysql2` adapter support this function.

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/hamuyuuki/activerecord-creating_foreign_keys. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
`activerecord-creating_foreign_keys` is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
