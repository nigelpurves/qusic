class Micropost < ActiveRecord::Base
  attr_accessible :artist, :track
  
  belongs_to :user
  
  validates :artist,  :presence => true, :length => { :maximum => 140 }
  validates :track,   :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  
  default_scope :order => 'microposts.created_at DESC'
end
