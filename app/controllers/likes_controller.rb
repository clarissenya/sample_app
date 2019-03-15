class LikesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]

	def create
		@micropost = Micropost.find(params[:micropost_id])
		current_user.add_like(@micropost)
		respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
	end

	def destroy
		@micropost = Micropost.find(params[:micropost_id])
		current_user.remove_like(@micropost)
		respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
	end
end
