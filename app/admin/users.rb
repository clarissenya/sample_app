ActiveAdmin.register User do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :name, :email, :password, :password_confirmation,
 							 :admin, :activated
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

	index do
	  selectable_column
	  id_column
	  column :name
	  column :email
	  column :admin
	  column :created_at
	  column :updated_at
	  column :activated
	  column :activated_at
	  actions
	end

	filter :name
	filter :email
	filter :following
	filter :followers
	filter :created_at
	filter :updated_at
	filter :admin
	filter :activated
	filter :activated_at

	form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin
      f.input :activated
      f.input :activated_at
    end
    f.actions
  end

end
