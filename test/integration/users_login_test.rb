require 'test_helper'

# go to login
# verify sessions form renders correctly
# post, with invalid values
# assert page has re-rendered
# assert flash present
# click to home
# assert_not flash present

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid params" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "chicken@example",
                                          password: "12"} }
    assert_template "sessions/new"
    assert_not flash.empty? # ".alert-danger", /.+/ # non-empty flash
    get root_path
    # assert_not ".alert-danger"
    assert flash.empty?
  end
end
