require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
  end

  test "edit user with invalid params" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { password: "12345",
                                                email: "foo@invalid",
                                                confirmation: "1234",
                                                name: ""} }
    assert_template "users/edit"
    assert_select ".alert-danger", "The form contains 4 errors."
  end

    test "edit user with valid params" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Davey Kerrigan"
    email = "davey@gmail.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              confirmation: "" } }
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?
    @user.reload
    assert_equal name, @user.name
    assert_select ".user_info h1", "Davey Kerrigan"
    assert_equal "Davey Kerrigan", @user.name
    assert_not session[:forwarding_url]
  end
end
