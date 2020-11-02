# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_record/creating_foreign_keys/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activerecord-creating_foreign_keys"
  s.version     = ActiveRecord::CreatingForeignKeys::VERSION
  s.authors     = ["hamuyuuki"]
  s.email       = ["13702378+hamuyuuki@users.noreply.github.com"]
  s.homepage    = "https://github.com/hamuyuuki/activerecord-creating_foreign_keys"
  s.summary     = "Create FOREIGN KEY Constraints in a CREATE TABLE Statement"
  s.description = "`activerecord-creating_foreign_keys` creates FOREIGN KEY Constraints in a CREATE TABLE Statement."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "rubocop"
  s.add_development_dependency "rubocop-rails"
  s.add_development_dependency "rubocop-performance"
  s.add_development_dependency "rubocop-packaging"
  s.add_development_dependency "sqlite3", "~> 1.3.0"
end
