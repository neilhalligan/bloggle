require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title should get full title" do
    assert_equal full_title, "Bloggle"
    assert_equal full_title("Test"), "Test | Bloggle"
  end
end
