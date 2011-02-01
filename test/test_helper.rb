require "rubygems"
require "bundler/setup"

$LOAD_PATH.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

ENV["RAILS_ENV"] = "test"
require File.expand_path("dummy/config/environment", File.dirname(__FILE__))
require File.expand_path("dummy/db/schema", File.dirname(__FILE__))
require "rails/test_help"

ActiveRecord::Base.connection.class.class_eval do
  def execute_with_query_record(sql, name = nil, &block)
    ($queries_executed ||= []) << sql
    execute_without_query_record(sql, name, &block)
  end
  alias_method_chain :execute, :query_record
end

class ActiveSupport::TestCase
  setup :create_widgets
  teardown :destroy_widgets

  def count_queries
    $queries_executed = []
    yield
    $queries_executed.size
  end

  def assert_equal_relation(expected, actual)
    assert_kind_of ActiveRecord::Relation, actual
    assert_equal expected.to_a, actual.to_a
  end

  def create_widgets
    177.times { Widget.connection.insert "INSERT INTO widgets (deleted) VALUES (0)" }
  end

  def destroy_widgets
    Widget.delete_all
  end
end
