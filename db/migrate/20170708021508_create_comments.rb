class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :description
      t.integer :chef_id
      t.integer :recipe_id
    end
  end
end
