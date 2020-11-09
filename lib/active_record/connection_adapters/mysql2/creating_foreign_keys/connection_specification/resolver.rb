# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module Mysql2
      module CreatingForeignKeys
        module ConnectionSpecification
          module Resolver
            def spec(config)
              connection_specification = super(config)

              if connection_specification.config[:adapter] == "mysql2"
                require "active_record/connection_adapters/mysql2/creating_foreign_keys/schema_creation"
                require "active_record/connection_adapters/mysql2/creating_foreign_keys/schema_statements"

                ActiveRecord::ConnectionAdapters::Mysql2Adapter::SchemaCreation.prepend(ActiveRecord::ConnectionAdapters::Mysql2::CreatingForeignKeys::SchemaCreation)
                ActiveRecord::ConnectionAdapters::Mysql2Adapter.prepend(ActiveRecord::ConnectionAdapters::Mysql2::CreatingForeignKeys::SchemaStatements)
              end

              connection_specification
            end
          end
        end
      end
    end
  end
end
