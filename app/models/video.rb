class Video < ActiveRecord::Base
  attr_accessible :description, :length, :mpaa, :title, :year, :file_name, :netflix_url
  
  has_and_belongs_to_many :directors
  has_and_belongs_to_many :actors
  has_and_belongs_to_many :genres
end
