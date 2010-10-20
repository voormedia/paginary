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
  
  def builder(*args)
    builder = nil
    paginate(*args) { |b| builder = b }
    builder
  end
  
  # Items ====================================================================
  test "items should return paginated relation" do
    assert_equal_relation @relation.paginate, builder(@relation).items
  end

  # Decorated links ==========================================================
  test "links should return nil if there is only one page" do
    assert_nil builder(@relation.paginate(:per_page => 12345)).links
  end
  
  test "links should return complete page links" do
    assert_dom_equal %Q{<div class="pagination">} +
      %Q{<span class="previous disabled"><span>&lt; Previous</span></span>} +
      %Q{<a href="/widgets?page=1" class="page selected"><span>1</span></a>} +
      %Q{<a href="/widgets?page=2" class="page"><span>2</span></a>} +
      %Q{<a href="/widgets?page=3" class="page"><span>3</span></a>} +
      %Q{<a href="/widgets?page=4" class="page"><span>4</span></a>} +
      %Q{<a href="/widgets?page=2" class="next"><span>Next &gt;</span></a>} +
      %Q{</div>}, builder(@relation).links
  end

  test "page_links should return page links" do
    assert_dom_equal %Q{<a href="/widgets?page=1" class="page selected"><span>1</span></a>} +
      %Q{<a href="/widgets?page=2" class="page"><span>2</span></a>} +
      %Q{<a href="/widgets?page=3" class="page"><span>3</span></a>} +
      %Q{<a href="/widgets?page=4" class="page"><span>4</span></a>}, builder(@relation).page_links
  end
  
  test "next_link should return link to next page" do
    assert_dom_equal %Q{<a href="/widgets?page=2" class="next"><span>Next &gt;</span></a>}, builder(@relation).next_link
  end

  test "next_link should return disabled link to next page if current page is last" do
    params[:page] = (@relation.count.to_f / 50).ceil
    assert_dom_equal %Q{<span class="next disabled"><span>Next &gt;</span></span>}, builder(@relation).next_link
  end

  test "previous_link should return link to previous page" do
    params[:page] = (@relation.count.to_f / 50).ceil
    assert_dom_equal %Q{<a href="/widgets?page=#{params[:page] - 1}" class="previous"><span>&lt; Previous</span></a>}, builder(@relation).previous_link
  end

  test "previous_link should return disabled link to previous page if current page is first" do
    assert_dom_equal %Q{<span class="previous disabled"><span>&lt; Previous</span></span>}, builder(@relation).previous_link
  end
end
