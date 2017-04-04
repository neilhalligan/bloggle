module ApplicationHelper
  def full_title(title = "")
    base_title = "Bloggle"
    if title.empty?
      base_title
    else
      "#{base_title} | #{title}"
    end
  end
end
