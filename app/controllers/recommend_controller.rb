class RecommendController < ApplicationController
  before_action :logged_in_user

  def index
    @users = current_user.people_to_follow(25)
  end
end
