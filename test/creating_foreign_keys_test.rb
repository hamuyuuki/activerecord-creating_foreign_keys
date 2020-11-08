# frozen_string_literal: true

require "test_helper"
require "active_support/test_case"

class CreatingForeignKeysTest < ActiveSupport::TestCase
  # ref: https://github.com/rails/rails/blob/4-2-stable/activerecord/test/cases/test_case.rb#L82L120
  class SQLCounter
    class << self
      attr_accessor :ignored_sql, :log, :log_all
      def clear_log; self.log = []; self.log_all = []; end
    end

    self.clear_log

    self.ignored_sql = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SAVEPOINT/, /^ROLLBACK TO SAVEPOINT/, /^RELEASE SAVEPOINT/, /^SHOW max_identifier_length/, /^BEGIN/, /^COMMIT/]

    # FIXME: this needs to be refactored so specific database can add their own
    # ignored SQL, or better yet, use a different notification for the queries
    # instead examining the SQL content.
    oracle_ignored     = [/^select .*nextval/i, /^SAVEPOINT/, /^ROLLBACK TO/, /^\s*select .* from all_triggers/im, /^\s*select .* from all_constraints/im, /^\s*select .* from all_tab_cols/im]
    mysql_ignored      = [/^SHOW TABLES/i, /^SHOW FULL FIELDS/, /^SHOW CREATE TABLE /i, /^SHOW VARIABLES /, /^\s*SELECT column_name\b.*\bFROM information_schema\.key_column_usage\b/im]
    postgresql_ignored = [/^\s*select\b.*\bfrom\b.*pg_namespace\b/im, /^\s*select tablename\b.*from pg_tables\b/im, /^\s*select\b.*\battname\b.*\bfrom\b.*\bpg_attribute\b/im, /^SHOW search_path/i]
    sqlite3_ignored =    [/^\s*SELECT name\b.*\bFROM sqlite_master/im, /^\s*SELECT sql\b.*\bFROM sqlite_master/im]

    [oracle_ignored, mysql_ignored, postgresql_ignored, sqlite3_ignored].each do |db_ignored_sql|
      ignored_sql.concat db_ignored_sql
    end

    attr_reader :ignore

    def initialize(ignore = Regexp.union(self.class.ignored_sql))
      @ignore = ignore
    end

    def call(name, start, finish, message_id, values)
      sql = values[:sql]

      # FIXME: this seems bad. we should probably have a better way to indicate
      # the query was cached
      return if "CACHE" == values[:name]

      self.class.log_all << sql
      self.class.log << sql unless ignore =~ sql
    end
  end

  # ref: https://github.com/rails/rails/blob/4-2-stable/activerecord/test/cases/test_case.rb#L122
  ActiveSupport::Notifications.subscribe("sql.active_record", SQLCounter.new)

  # ref: https://github.com/rails/rails/blob/4-2-stable/activerecord/test/cases/test_case.rb#L49L61
  def assert_queries(num = 1, options = {})
    ignore_none = options.fetch(:ignore_none) { num == :any }
    SQLCounter.clear_log
    x = yield
    the_log = ignore_none ? SQLCounter.log_all : SQLCounter.log
    if num == :any
      assert_operator the_log.size, :>=, 1, "1 or more queries expected, but none were executed."
    else
      mesg = "#{the_log.size} instead of #{num} queries were executed.#{the_log.size == 0 ? '' : "\nQueries:\n#{the_log.join("\n")}"}"
      assert_equal num, the_log.size, mesg
    end
    x
  end

  # ref: https://github.com/rails/rails/blob/4-2-stable/activerecord/test/cases/migration/references_foreign_key_test.rb#L7L10
  setup do
    @connection = ActiveRecord::Base.connection
    @connection.create_table(:testing_parents, force: true)
  end

  # ref: https://github.com/rails/rails/blob/4-2-stable/activerecord/test/cases/migration/references_foreign_key_test.rb#L12L15
  #      https://github.com/rails/rails/blob/4-2-stable/activerecord/test/cases/test_case.rb#L8L10
  teardown do
    @connection.drop_table "testings", if_exists: true
    @connection.drop_table "testing_parents", if_exists: true
    SQLCounter.clear_log
  end

  # ref: https://github.com/rails/rails/pull/20009/files#diff-753b84de930c3ef1f329af181b7fd7b21957e5c022765ca81748cda3002eb58dR35-R42
  test "foreign keys can be created in one query with MySQL" do
    assert_queries(1) do
      @connection.create_table :testings do |t|
        t.references :testing_parent, foreign_key: true
      end
    end
  end
end
