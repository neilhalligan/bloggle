require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", help_path, count: 2
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", signup_path, count: 1
  end
end

# Get the root path (Home page).
# Verify that the right page template is rendered.
# Check for the correct links to the Home, Help, About, and Contact pages.
