class StaticPagesController < ApplicationController
  
  def home
    if logged_in?       
      @feed_items = current_user.feed.paginate(page: params[:page])
      @users = current_user.people_to_follow(3)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
