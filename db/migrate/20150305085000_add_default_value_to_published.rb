class AddDefaultValueToPublished < ActiveRecord::Migration
  def change
    change_column :articles, :published, :boolean, default: false
  end
end
