require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:dave)
    @post = @user.posts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "requires user_id" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "content should be present" do
    @post.content = "     "
    assert_not @post.valid?
  end

  test "belongs to user" do
    assert @post.user
  end

  test "post should be at most 140 characters" do
    @post.content = "a"*141
    assert_not @post.valid?
  end

  test "most recent post should be first" do
    assert_equal posts(:most_recent), Post.first
  end
end
