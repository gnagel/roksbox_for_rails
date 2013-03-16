class VideosActors < ActiveRecord::Base
  belongs_to :video
  belongs_to :actor
  # attr_accessible :title, :body
end
