class VideosGenres < ActiveRecord::Base
  belongs_to :video
  belongs_to :genre
  # attr_accessible :title, :body
end
