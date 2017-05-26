require 'test_helper'

class PostInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
  end

  test "test posts add and delete" do
    log_in_as(@user)
    get root_path
    assert_select "form.new_post"
    assert_select "div.pagination"
    assert_select "input[type=?]", "file"
    # attempt create invalid post
    assert_no_difference "Post.count" do
      post posts_path, params: { post: { content: "I"*142 } }
    end
    assert_select "div#error_explanation"
    assert_select "ol.posts", count: 0
    # create valid post
    assert_difference "Post.count", 1 do
      photo = fixture_file_upload('test/fixtures/rails.png', 'image/png')
      content = "Ipsum lorem"
      post posts_path, params: { post: { content: content, photo: photo } }
    end
    post = assigns(:post)
    assert_redirected_to root_url
    follow_redirect!
    assert_select "span.content", text: "Ipsum lorem"
    assert post.photo?
    # delete post
    assert_select "a", text: "delete"
    assert_difference "Post.count", -1 do
      delete post_path(post)
    end
    assert_redirected_to root_url
    # visit different user, no delete links
    other_user = users(:archer)
    get user_path(other_user)
    assert_select "a", text: "delete", count: 0
  end
end
