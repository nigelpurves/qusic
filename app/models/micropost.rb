class Micropost < ActiveRecord::Base
  attr_accessible :artist, :track
  
  belongs_to :user
end
