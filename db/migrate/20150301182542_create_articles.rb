class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.boolean :published
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :articles, :users
  end
end
