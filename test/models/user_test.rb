require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "John", email: "john@gmail.com",
                     password: "foobar", password_confirmation: "foobar", activated: true, activated_at: Time.zone.now)
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

  test "should destroy dependent posts" do
    @user.save
    @user.posts.create!(content: "Lorem ipsum")
    assert_difference "Post.count", -1 do
      @user.destroy
    end
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
    assert_not @user.authenticated?(:remember, "")
  end

  test "admin defaults to false" do
    assert_not @user.admin?
  end

  test "verify create callback defines activation_token and activation_digest" do
    assert_nil @user.activation_token
    assert_nil @user.activation_digest
    @user.save
    assert_not_nil @user.activation_token
    assert_not_nil @user.activation_digest
  end

  test "should follow and unfollow a user" do
    other_user = users(:dave)
    steve = users(:steve)
    assert_not steve.following?(other_user)
    steve.follow(other_user)
    assert steve.following?(other_user)
    assert other_user.followers.include?(steve)
    steve.unfollow(other_user)
    assert_not steve.following?(other_user)
  end

  test "feed should only show followed and self posts" do
    dave = users(:dave)
    lana = users(:lana)
    archer = users(:archer)
    # self posts
    dave.posts.each do |post_self|
      assert dave.feed.include?(post_self)
    end
    # followed posts
    lana.posts.each do |post_followed|
      assert dave.feed.include?(post_followed)
    end
    # unfollowed posts
    archer.posts.each do |post_unfollowed|
      assert_not dave.feed.include?(post_unfollowed)
    end
  end
end

