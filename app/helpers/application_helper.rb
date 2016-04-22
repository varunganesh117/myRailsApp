module ApplicationHelper
  def full_title(title="")
    default = "Ruby on Rails Tutorial Sample App"
    if title.empty?
      return default
    else
      return title + " | " + default
    end
  end
end
