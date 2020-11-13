# frozen_string_literal: true

module ActiveRecord
  module CreatingForeignKeys
    module SchemaCreation
      private
        def visit_TableDefinition(o)
          return super(o) if o.foreign_keys.empty?

          name = o.name
          create_sql = +"CREATE#{' TEMPORARY' if o.temporary} TABLE #{quote_table_name(name)} "

          statements = o.columns.map { |c| accept c }
          statements.concat(o.indexes.map { |column_name, options| index_in_create(name, column_name, options) })
          statements.concat(o.foreign_keys.map { |to_table, options| foreign_key_in_create(o.name, to_table, options) })

          create_sql << "(#{statements.join(', ')}) " if statements.present?
          create_sql << "#{o.options}"
          create_sql << " AS #{@conn.to_sql(o.as)}" if o.as
          create_sql
        end

        def visit_ForeignKeyDefinition(o)
          sql = +<<-SQL.strip_heredoc
            CONSTRAINT #{quote_column_name(o.name)}
            FOREIGN KEY (#{quote_column_name(o.column)})
              REFERENCES #{quote_table_name(o.to_table)} (#{quote_column_name(o.primary_key)})
          SQL
          sql << " #{action_sql('DELETE', o.on_delete)}" if o.on_delete
          sql << " #{action_sql('UPDATE', o.on_update)}" if o.on_update
          sql
        end

        def foreign_key_in_create(from_table, to_table, options)
          options = @conn.foreign_key_options(from_table, to_table, options)
          accept ActiveRecord::ConnectionAdapters::ForeignKeyDefinition.new(from_table, to_table, options)
        end
    end
  end
end
