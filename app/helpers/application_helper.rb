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
  # 高亮
  def render_highlight_content(group,query_string)
    excerpt_cont = excerpt(group, query_string, radius: 500)
    highlight(excerpt_cont, query_string)
	end
end
