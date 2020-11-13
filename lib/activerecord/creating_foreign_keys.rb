# frozen_string_literal: true

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:active_record) do
  require "activerecord/creating_foreign_keys/connection_specification/resolver"

  ActiveRecord::ConnectionAdapters::ConnectionSpecification::Resolver.prepend(ActiveRecord::CreatingForeignKeys::ConnectionSpecification::Resolver)
end
