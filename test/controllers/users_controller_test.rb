require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
    @other_user = users(:steve)
    @admin = users(:archer)
    @unactivated_user = users(:karen)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit when other user" do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect update when other user" do
    log_in_as(@user)
    patch user_path(@other_user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect show when user not activated" do
    get user_path(@unactivated_user), params: { id: @unactivated_user.id }
    assert_redirected_to root_path
  end

  test "should redirect index if not logged in" do
    get users_path
    assert_redirected_to login_path
  end

  test "should not be able to change admin with patch request" do
    assert_not @other_user.admin?
    log_in_as(@other_user)
    patch user_path(@other_user), params: { user: { password: "123456",
                                                    confirmation: "123456",
                                                    admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "User.count" do
      delete user_path(@other_user)
    end
    assert_redirected_to login_path
  end

  test "normal user cannot delete users" do
    log_in_as(@user)
    assert_no_difference "User.count" do
      delete user_path(@other_user)
    end
    assert_redirected_to root_path
  end

  test "admin can delete users" do
    log_in_as(@admin)
    assert_difference "User.count", -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to users_path
  end
end

