require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'active_record'

ActiveRecord::Migration.verbose = false # quiet down the migration engine
ActiveRecord::Base.configurations = { 'test' => {
    'adapter' => 'sqlite3', 'database' => ':memory:'
}}
silence_warnings { RAILS_ENV = "test" }
ActiveRecord::Base.establish_connection('test')
ActiveRecord::Base.silence do
  load File.join(File.dirname(__FILE__), 'schema.rb')
end

require File.join(File.dirname(__FILE__), '../lib/alias_association')
ActiveRecord::Base.send :include, AliasAssociation
