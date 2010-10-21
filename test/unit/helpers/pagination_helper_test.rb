require File.expand_path("../../test_helper", File.dirname(__FILE__))

class PaginationHelperTest < ActionView::TestCase
  include Paginary::Helpers::PaginationHelper

  delegate :params, :to => :controller
  
  def url_options
    { :controller => "widgets", :action => "index" }
  end
  
  def setup
    @klass = Widget
    @relation = @klass.unscoped
  end

  # Pagination ===============================================================
  test "paginate should yield page builder" do
    builder = nil
    paginate(@relation) { |b| builder = b }
    assert_kind_of Paginary::Helpers::PageBuilder, builder
  end
  
  test "paginate should accept builder class" do
    custom_builder = Class.new(Paginary::Helpers::PageBuilder)
    builder = nil
    paginate(@relation, :builder => custom_builder) { |b| builder = b }
    assert_kind_of custom_builder, builder
  end
  
  test "paginate should query database for total number of items only once" do
    num = count_queries do
      paginate(@relation) { |page| page.links; page.items.to_a }
    end
    assert_equal 2, num
  end
end
