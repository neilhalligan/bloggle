require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test "valid signup information" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "John Bonham",
                                         email: "johnty@gmail.com",
                                         password: "foobar",
                                         password_confirmation: "foobar" } }
    end
    follow_redirect!
    assert_template "users/show"
    assert_select ".alert-success", { count: 1, text: /.+/ }
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(User.last)
  end

end

