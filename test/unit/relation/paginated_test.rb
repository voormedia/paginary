require File.expand_path("../../test_helper", File.dirname(__FILE__))

class PaginatedTest < ActiveRecord::TestCase
  def setup
    @klass = Widget
    @relation = @klass.scoped
  end
  
  # Relation methods =========================================================
  test "item_count should return number of items without pagination" do
    assert_equal @klass.count, @relation.paginate.item_count
  end

  test "page_count should return number of pages" do
    assert_equal (@klass.count.to_f / 17).ceil, @relation.paginate(:per_page => 17).page_count
  end

  test "current_page should return one by default" do
    assert_equal 1, @relation.paginate.current_page
  end

  test "current_page should return given page" do
    assert_equal 3, @relation.paginate(3).current_page
  end

  test "last_page? should return false if there is a next page" do
    assert_equal false, @relation.paginate(1).last_page?
  end

  test "last_page? should return true if there is no next page" do
    assert_equal true, @relation.paginate((@klass.count.to_f / 50).ceil).last_page?
  end

  test "first_page? should return false if there is a previous page" do
    assert_equal false, @relation.paginate(2).first_page?
  end

  test "first_page? should return true if there is no previous page" do
    assert_equal true, @relation.paginate(1).first_page?
  end
  
  # Page validation ==========================================================
  test "paginate should set current page if given page is an integer string" do
    assert_equal 2, @relation.paginate("2").current_page
  end
  
  test "paginate should raise error if given page is less than one" do
    assert_raises ActiveRecord::RecordNotFound do
      @relation.paginate(0)
    end
  end

  test "paginate should raise error if given page does not exist" do
    assert_raises ActiveRecord::RecordNotFound do
      @relation.paginate(1239)
    end
  end
  
  test "paginate should raise error if given page is not well formatted" do
    assert_raises ActiveRecord::RecordNotFound do
      @relation.paginate("1.5")
    end
  end
  
  # Page calculation =========================================================
  test "page_count should return 1 if there are no items" do
    assert_equal 1, @relation.where(:deleted => true).paginate.page_count
  end
  
  test "page_count should return 1 if number of items is within number of items per page" do
    16.times { Widget.create! :deleted => true }
    assert_equal 1, @relation.where(:deleted => true).paginate(:per_page => 17).page_count
  end

  test "page_count should return 1 if number of items is equal to number of items per page" do
    17.times { Widget.create! :deleted => true }
    assert_equal 1, @relation.where(:deleted => true).paginate(:per_page => 17).page_count
  end

  test "page_count should return 2 if number of items is larger than number of items per page" do
    18.times { Widget.create! :deleted => true }
    assert_equal 2, @relation.where(:deleted => true).paginate(:per_page => 17).page_count
  end
end
