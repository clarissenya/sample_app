class ChangeUsers < ActiveRecord::Migration[5.1]
  def change
  	change_table :users do |t|
  		t.string :user_type
  		t.string :type
  	end
  end
end
