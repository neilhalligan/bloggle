require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
  end

  test "need to be logged in to follow user" do
    assert_no_difference "Relationship.count" do
      post relationships_path
    end
    assert_redirected_to login_path
  end

  test "need to be logged in to unfollow user" do
    assert_no_difference "Relationship.count" do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_path
  end
end
