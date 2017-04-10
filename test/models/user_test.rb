require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "John", email: "john@gmail.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name required" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email required" do
    @user.email = "     "
  end

  test "name max 50 chars" do
    @user.name = "F"*51
    assert_not @user.valid?
  end

  test "email max 255 chars" do
    @user.email = "x"*256
    assert_not @user.valid?
  end

  test "should accept valid email addresses" do
    valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                       first.last@foo.jp alice+bob@baz.cn]
    valid_emails.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "should reject invalid email addresses" do
    invalid_emails = %w[user@example,com user_at_foo.org user.name@example.
                      foo@bar_baz.com foo@bar+baz.com]
    invalid_emails.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be unique and case insensitive" do
    @user.email.downcase!
    @user.save
    new_user = @user.dup
    assert_not new_user.valid?
  end

  test "email should be converted to downcase before save" do
    @user.email = "JOHN@email.com"
    @user.save
    assert_equal @user.reload.email, "john@email.com"
  end

  test "password must be at least 6 chars" do
    @user.password = @user.password_confirmation = "3"*5
    assert_not @user.valid?
  end

  test "password must not contain spaces" do
    @user.password = @user.password_confirmation = "fd  l3"
    assert_not @user.valid?
  end

  test "authenticated should return false for a user with nil digest" do
    @user.remember_digest = nil
    assert_not @user.authenticated?("")
  end

  test "admin defaults to false" do
    assert_not @user.admin?
  end
end

