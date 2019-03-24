ActiveAdmin.register Micropost do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 	permit_params :content, :user_id, :picture, :id
 	actions :all, except: :edit
	
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

	index  do |post|
		 selectable_column
		 id_column
		 column :user
		 column :content
		 column :created_at
		 actions
	end

	index as: :blog do
		title do |post|
			span post.user.name
			span "——————"
			span post.created_at 
		end

		body do |post|
			div post.content, class: "text"
			div link_to image_tag(post.picture.url), admin_micropost_path(post) if post.picture?								
		end
	end 

	filter :user, label: "user name"
	filter :likers
	filter :content
	filter :created_at

end
