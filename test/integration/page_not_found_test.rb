require File.expand_path("../test_helper", File.dirname(__FILE__))

class PageNotFoundTest < ActionDispatch::IntegrationTest
  def setup
    self.remote_addr = "208.77.188.166" # example.com
  end

  # Normal operation =========================================================
  test "paged request should succeed" do
    get "/widgets?page=1"
    assert_response 200
  end

  # Error handling ===========================================================
  test "page below one should cause an internal server error" do
    get "/widgets?page=0"
    assert_response 500
  end

  test "page above maximum number of pages should cause an internal server error" do
    get "/widgets?page=123"
    assert_response 500
  end

  test "page below one should cause a not found error if paginated from controller" do
    get "/widgets.xml?page=0"
    assert_response 404
  end

  test "page above maximum number of pages should cause a not found error if paginated from controller" do
    get "/widgets.xml?page=123"
    assert_response 404
  end
end
