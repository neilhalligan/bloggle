require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
  end

  test "login with invalid params" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "chicken@example",
                                          password: "12"} }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid param followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                       password: "123456" } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user.id)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,       count: 0
    assert_select "a[href=?]", users_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: "1")
    assert_equal assigns[:user].remember_token, cookies["remember_token"]
  end

  test "login details without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
