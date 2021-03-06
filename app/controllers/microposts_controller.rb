class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  

  def show
    @micropost = Micropost.find(params[:id])
    @comments = @micropost.comments.paginate(page: params[:page])
  end

  def create
  	@micropost = current_user.microposts.build(micropost_params)
  	if @micropost.save
  		flash[:success] = "Micropost created!"
      redirect_to root_url
     else
      @feed_items = current_user.feed.paginate(page: params[:page])
      redirect_to root_url
    end
  end

  def destroy
    Micropost.find_by(id: params[:id]).destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

  	def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      if current_user.admin?
        @micropost = Micropost.find_by(id: params[:id])
      else 
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
      end
    end
end
	