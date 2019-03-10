class CommentsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user,   only: :destroy

	def create
		@micropost = Micropost.find(params[:micropost_id])
		@comment = current_user.comments.build(content: params[:comment][:content], micropost_id: @micropost.id)
		if @comment.save
			flash[:success] = "comment created!"
			redirect_to @micropost
		else
			flash[:danger] = "Comment Failure"
      redirect_to @micropost
		end
	end

	def destroy
		@comment.destroy
		flash[:success] = "Comment deleted"
		redirect_to request.referrer || root_url
	end

	private

		def comment_params
      params.require(:comment).permit(:content, :micropost_id)
    end

		def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end
