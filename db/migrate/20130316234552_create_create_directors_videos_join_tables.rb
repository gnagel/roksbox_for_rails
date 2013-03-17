class CreateCreateDirectorsVideosJoinTables < ActiveRecord::Migration
  def change
    create_table :directors_videos, :id => false do |t|
      t.references :video
      t.references :director
    end
    add_index :directors_videos, [:video_id, :director_id], :unique => true
  end
end
