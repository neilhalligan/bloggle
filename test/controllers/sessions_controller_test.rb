require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  # def setup
  #   @session = Session.new
  # end
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should get create" do
    assert_difference "Session.count", 1 do
      post login_path, params: {}
    end
  end

  test "should destroy session" do
    assert_difference "Session.count", -1 do
      delete logout_path(@session), params: {} #  id: @session.id
    end
  end


end
