# frozen_string_literal: true

module ActiveRecord
  module CreatingForeignKeys
    module ConnectionSpecification
      module Resolver
        def spec(config)
          connection_specification = super(config)

          if connection_specification.config[:adapter] == "mysql2"
            require "activerecord/creating_foreign_keys/schema_creation"
            require "activerecord/creating_foreign_keys/schema_statements"

            ActiveRecord::ConnectionAdapters::Mysql2Adapter::SchemaCreation.prepend(ActiveRecord::CreatingForeignKeys::SchemaCreation)
            ActiveRecord::ConnectionAdapters::Mysql2Adapter.prepend(ActiveRecord::CreatingForeignKeys::SchemaStatements)
          end

          connection_specification
        end
      end
    end
  end
end
