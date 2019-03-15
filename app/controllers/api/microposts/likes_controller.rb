class API::Microposts::LikesController < ApplicationController

	def create
		@micropost = Micropost.find(params[:micrpost_id])
		@like = current_user.likes.create(likeable_id: @micropost.id, likeable_type: 'Micropost')
		redirect_to root_url
	end
end