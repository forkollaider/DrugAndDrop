class AddOriginalUrl < ActiveRecord::Migration
  def change
    add_column :uploads, :url_original, :string
  end
end
