class CreateActorsVideosJoinTables < ActiveRecord::Migration
  def change
    create_table :actors_videos, :id => false do |t|
      t.references :video
      t.references :actor
    end
    add_index :actors_videos, [:video_id, :actor_id], :unique => true
  end
end
