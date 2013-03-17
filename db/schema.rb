# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130316234552) do

  create_table "actors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "actors_videos", :id => false, :force => true do |t|
    t.integer "video_id"
    t.integer "actor_id"
  end

  add_index "actors_videos", ["video_id", "actor_id"], :name => "index_actors_videos_on_video_id_and_actor_id", :unique => true

  create_table "directors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "directors_videos", :id => false, :force => true do |t|
    t.integer "video_id"
    t.integer "director_id"
  end

  add_index "directors_videos", ["video_id", "director_id"], :name => "index_directors_videos_on_video_id_and_director_id", :unique => true

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "genres_videos", :id => false, :force => true do |t|
    t.integer "video_id"
    t.integer "genre_id"
  end

  add_index "genres_videos", ["video_id", "genre_id"], :name => "index_genres_videos_on_video_id_and_genre_id", :unique => true

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.integer  "year"
    t.integer  "length"
    t.string   "mpaa"
    t.text     "description"
    t.text     "file_name"
    t.text     "netflix_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
