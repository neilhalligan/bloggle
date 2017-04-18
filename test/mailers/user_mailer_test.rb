require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:dave)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Bloggle | Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@bloggle.com"], mail.from
    assert_match user.activation_token, mail.body.encoded
    assert_match user.name, mail.body.encoded
    # contains full activation link
    assert_match "https://secret-stream-58448.herokuapp.com/"\
                 "account_activations/#{user.activation_token}/"\
                 "edit?email=#{CGI.escape(user.email)}", mail.body.encoded
  end

  test "password_reset" do
    user = users(:dave)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Bloggle | Password rest", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@bloggle.com"], mail.from
    assert_match user.reset_token, mail.body.encoded
    # contains full activation link
    assert_match "https://secret-stream-58448.herokuapp.com/"\
                 "password_resets/#{user.reset_token}/"\
                 "edit?email=#{CGI.escape(user.email)}", mail.body.encoded
  end
end
