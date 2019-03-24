class SearchController < ApplicationController
	 before_action :validate_search_key, only: [:search]

  def search
    if params[:q].present?
      @users = User.ransack(@search_user).result(:distinct => true).paginate(:page => params[:page])
      @microposts = Micropost.ransack(@search_micropost).result(:distinct => true).paginate(:page => params[:page])
    end
  end

 protected

   def validate_search_key
     @query_string = params[:q] if params[:q].present?
     @search_user = search_user(@query_string)
     @search_micropost = search_micropost(@query_string)
   end

   def search_user(query_string)
     { name_cont: query_string }
   end

   def search_micropost(query_string)
   	 { content_cont: query_string}
   end
end