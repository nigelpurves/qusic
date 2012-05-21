class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation    # This tells Rails which attributes of the model are accessible ie which can be modified by outside users (eg users submitting requests with web browsers)
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,     :presence     => true,
                       :length       => { :maximum => 50 }
  validates :email,    :presence     => true,
                       :format       => { :with => email_regex },
                       :uniqueness   => { :case_sensitive => false }  # rails automatically infers here that :uniqueness should be true, so we can write the false in the case_sensitive part
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
  
  before_save :encrypt_password
  
  # return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of submitted password.
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  private # inside a Ruby class, all methods defined after private are used internally by the object & are not intended for public use.  Note also the extra indentation (not necessary but can be v helpful)
  
    def encrypt_password
      self.salt = make_salt if new_record?  # since the salt is unique to each user we don't want it to change every time the user is updated
      self.encrypted_password = encrypt (password) # self is NOT optional when assigning to an attribute, but it is in the second part (which could be: encrypt (self.password))
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
      # since we're inside the user class, Ruby knows that salt refers to the user's salt attribute
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end  
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end