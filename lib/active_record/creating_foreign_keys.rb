# frozen_string_literal: true

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:active_record) do
  require "active_record/creating_foreign_keys/schema_creation"
  require "active_record/creating_foreign_keys/schema_statements"
  # どのようにして、MySQL Adapterを読み込むことができるようにするのか？を検討したい。
  require "active_record/connection_adapters/abstract_mysql_adapter"

  ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::SchemaCreation.prepend(ActiveRecord::CreatingForeignKeys::SchemaCreation)
  ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend(ActiveRecord::CreatingForeignKeys::SchemaStatements)
end
