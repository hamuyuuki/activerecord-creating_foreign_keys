# frozen_string_literal: true

module ActiveRecord
  module CreatingForeignKeys
    module SchemaStatements
      def create_table(table_name, options = {})
        td = create_table_definition table_name, options[:temporary], options[:options], options[:as]

        if options[:id] != false && !options[:as]
          pk = options.fetch(:primary_key) do
            Base.get_primary_key table_name.to_s.singularize
          end

          td.primary_key pk, options.fetch(:id, :primary_key), options
        end

        yield td if block_given?

        if options[:force] && table_exists?(table_name)
          drop_table(table_name, options)
        end

        result = execute schema_creation.accept td

        unless supports_indexes_in_create?
          td.indexes.each_pair do |column_name, index_options|
            add_index(table_name, column_name, index_options)
          end
        end

        result
      end

      def foreign_key_options(from_table, to_table, options) # :nodoc:
        options = options.dup
        options[:column] ||= foreign_key_column_for(to_table)
        options[:name]   ||= foreign_key_name(from_table, options)
        options
      end
    end
  end
end
