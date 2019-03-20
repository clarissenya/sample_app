class Admin::UsersController < ApplicationController
	before_action :admin_user
	
	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def update
		@user = User.find(params[:id])
	end

	def create
		@user = User.create(user_params)
		redirect_to admin_users_path
	end

	def destroy
		@user = User.find(params[:id]).destroy
		redirect_to admin_users_path
	end

	private
		def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :description, :avatar)
    end

		# 确保是管理员
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end