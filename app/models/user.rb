class User < ActiveRecord::Base
  attr_accessible(:name, :email)    # This tells Rails which attributes of the model are accessible ie which can be modified by outside users (eg users submitting requests with web browsers)
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,  :presence   => true,
                    :length     => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }  # rails automatically infers here that :uniqueness should be true, so we can write the false in the case_sensitive part
end
