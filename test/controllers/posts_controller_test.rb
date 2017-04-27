require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
    @post = @user.posts.create!(content: "Ipsum lorem")
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Post.count" do
      post posts_path, params: { post: { content: "Ipsum lorem" } }
    end
    assert_redirected_to login_path
  end

  test "should redirect create" do
    log_in_as(@user)
    assert_difference "Post.count", 1 do
      post posts_path, params: { post: { content: "Ipsum lorem" } }
    end
    assert_redirected_to root_url
  end

  test "should re-render create when post not saved" do
    log_in_as(@user)
    assert_no_difference "Post.count" do
      post posts_path, params: { post: { content: "I"*141 } }
    end
    assert_template "static_pages/home"
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Post.count" do
      delete post_path(@post)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy" do
    log_in_as(@user)
    assert_difference "Post.count", -1 do
      delete post_path(@post)
    end
    assert_redirected_to root_url
  end

  test "should not delete post different user" do
    post = posts(:orange)
    log_in_as(@user)
    assert_no_difference "Post.count" do
      delete post_path(post)
    end
    assert_redirected_to root_url
  end
end
