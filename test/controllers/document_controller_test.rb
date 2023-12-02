require "test_helper"

class DocumentControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get document_index_url
    assert_response :success
  end

  test "should get show" do
    get document_show_url
    assert_response :success
  end
end
