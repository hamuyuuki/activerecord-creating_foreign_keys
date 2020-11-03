
module ActiveRecord
  module CreatingForeignKeys
    module SchemaStatements
      def foreign_key_options(from_table, to_table, options) # :nodoc:
        options = options.dup
        options[:column] ||= foreign_key_column_for(to_table)
        options[:name]   ||= foreign_key_name(from_table, options)
        options
      end
    end
  end
end
