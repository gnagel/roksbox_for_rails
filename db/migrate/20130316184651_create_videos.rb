class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.integer :year
      t.integer :length
      t.string :mpaa
      t.text :description

      t.timestamps
    end
  end
end
