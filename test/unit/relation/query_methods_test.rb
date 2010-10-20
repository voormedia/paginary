require File.expand_path("../../test_helper", File.dirname(__FILE__))

class QueryMethodsTest < ActiveRecord::TestCase
  def setup
    @klass = Widget
    @relation = @klass.scoped
  end
  
  # Relation methods =========================================================
  test "paginate should return first fifty items by default" do
    assert_equal_relation @relation.limit(50), @relation.paginate
  end

  test "paginate should return second fifty items if page number is two" do
    assert_equal_relation @relation.offset(50).limit(50), @relation.paginate(2)
  end
  
  test "paginate should return first n items as specified by per_page" do
    assert_equal_relation @relation.limit(37), @relation.paginate(:per_page => 37)
  end
  
  test "paginated? should return true if paginate has been called" do
    assert_equal true, @relation.paginate.paginated?
  end

  test "paginated? should return false if paginate has not been called" do
    assert_equal false, @relation.paginated?
  end
  
  test "paginated? should return false if everything fits on one page" do
    assert_equal false, @relation.paginate(:per_page => 1234).paginated?
  end
  
  # Class methods ============================================================
  test "paginate on class should return first fifty items by default" do
    assert_equal_relation @relation.limit(50), @klass.paginate
  end
  
  test "paginated? on class should return false" do
    assert_equal false, @klass.paginated?
  end
end
