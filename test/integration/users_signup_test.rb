require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                         email: "johnty@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_select "div.alert-danger", 1
    assert_select "div#error_explanation", 1
    assert_template "users/new"
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "John Bonham",
                                         email: "johnty@gmail.com",
                                         password: "foobar",
                                         password_confirmation: "foobar" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    # can't log in before activation
    assert_not user.activated?
    log_in_as(user)
    # follow_redirect!
    assert_template root_path
    assert_not is_logged_in?
    # activation with wrong token
    get edit_account_activation_path("wrong_token", email: user.email)
    assert_not is_logged_in?
    follow_redirect!
    assert_template root_path
    # activation with wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong email")
    assert_not is_logged_in?
    # activation with correct email/token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?
  end

end
#check on root path
#check not valid
#try invalid login
# assert redirected to root
# assert flash message danger, not nil

#edit request with invalid token
# assert not logged in

#edit request with invalid email
# assert not logged in

#try valid login
# assert logged in
# assert on users template
# assert flash success, not empty
# assert_template root_path
