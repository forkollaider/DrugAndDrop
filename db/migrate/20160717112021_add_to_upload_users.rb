class AddToUploadUsers < ActiveRecord::Migration
  def change
    add_column :uploads, :url, :string
    add_column :uploads, :public_id, :string
    add_column :uploads, :user_id, :integer
  end
end
