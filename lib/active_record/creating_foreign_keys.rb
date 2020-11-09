# frozen_string_literal: true

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:active_record) do
  require "active_record/connection_adapters/mysql2/creating_foreign_keys/connection_specification/resolver"

  ActiveRecord::ConnectionAdapters::ConnectionSpecification::Resolver.prepend(ActiveRecord::ConnectionAdapters::Mysql2::CreatingForeignKeys::ConnectionSpecification::Resolver)
end
