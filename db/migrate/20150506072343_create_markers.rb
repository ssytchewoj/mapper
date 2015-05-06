class CreateMarkers < ActiveRecord::Migration
  def change
    create_table :markers do |t|
      t.string :title
      t.string :description

      t.float :lat
      t.float :lon

      t.integer :map_id

      t.timestamps null: false
    end
  end
end
