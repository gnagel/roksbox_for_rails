class Video < ActiveRecord::Base
  attr_accessible :description, :length, :mpaa, :title, :year
  
  has_and_belongs_to_many :actors
  has_and_belongs_to_many :genres
end
