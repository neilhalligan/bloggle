require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
  end

  test "layout links" do
    get root_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", help_path, count: 2
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", signup_path, count: 1
    log_in_as(@user)
    get root_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", help_path, count: 2
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", users_path, count: 1
    assert_select "a[href=?]", user_path(@user), count: 1
    assert_select "a[href=?]", logout_path, count: 1
  end

  test "get user show" do
    user = User.create!(name: "John", email: "john@gmail.com",
                 password: "foobar", password_confirmation: "foobar")
    get user_path(user.id)
    assert_response :success
  end
end

