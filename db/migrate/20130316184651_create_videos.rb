class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.integer :year
      t.integer :length
      t.string :mpaa
      t.text :description
      t.text :file_name
      t.text :netflix_url

      t.timestamps
    end
  end
end
