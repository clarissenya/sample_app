module ApplicationHelper

# 根据所在的页面提供完整标题
  def full_title(page_title = '')
  	base_title = "Ruby on Rails Sample App"
  	if page_title.empty?
  		base_title
  	else
  		page_title + " | " + base_title
  	end
  end
end
