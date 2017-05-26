require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
    @other_user = users(:archer)
    log_in_as @user
  end

  test "following" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_select "h3", "Following"
    @user.following.each do |followed|
      assert_select "a[href=?]", user_path(followed)
    end
  end

  test "followers" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_select "h3", "Followers"
    @user.followers.each do |follower|
      assert_select "a[href=?]", user_path(follower)
    end
  end

  test "follow standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other_user.id }
    end
  end

  test "follow with ajax" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other_user.id }
    end
  end

  test "unfollow standard way" do
    @user.follow(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "unfollow with ajax" do
    @user.follow(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
