require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:dave)
  end

  test "profile display" do
    get user_path(@user)
    assert_template "users/show"
    assert_select "title", full_title(@user.name)
    assert_select "h1", "Dave Kerrigan"
    assert_select "h1>img.gravatar"
    assert_match @user.posts.count.to_s, response.body
    assert_select "ol>li", 30 do
      assert_select "a[href=?]", "/users/#{@user.id}", count: 60
      assert_select "a>img.gravatar", 30
      assert_select "span.timestamp", 30
    end

    @user.posts.paginate(page: 1).each do |p|
      assert_match p.content, response.body
    end
  end
end
