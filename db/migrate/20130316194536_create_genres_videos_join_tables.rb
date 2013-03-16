class CreateGenresVideosJoinTables < ActiveRecord::Migration
  def change
    create_table :genres_videos, :id => false do |t|
      t.references :video
      t.references :genre
    end
    add_index :genres_videos, [:video_id, :genre_id], :unique => true
  end
end
