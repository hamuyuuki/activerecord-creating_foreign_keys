# frozen_string_literal: true

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:active_record) do
  require "active_record/creating_foreign_keys/schema_creation"
  require "active_record/creating_foreign_keys/schema_statements"
  # TODO: Should research the not `require` way
  require "active_record/connection_adapters/abstract_mysql_adapter"

  ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::SchemaCreation.prepend(ActiveRecord::CreatingForeignKeys::SchemaCreation)
  ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend(ActiveRecord::CreatingForeignKeys::SchemaStatements)
end
