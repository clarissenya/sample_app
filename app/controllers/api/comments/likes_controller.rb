class Api::Comments::LikesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]

	def create
		@comment = Comment.find(params[:comment_id])
		current_user.add_like(@comment)
		respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
	end

	def destroy
		@comment = Comment.find(params[:comment_id])
		current_user.remove_like(@comment)
		respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
	end
end