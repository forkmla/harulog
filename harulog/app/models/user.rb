class User < ActiveRecord::Base

  # accessors
  attr_accessor :password
 
  # public attributes
  attr_accessible :name, :email, :password, :password_confirmation

  # regular expression to check email format
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #validations
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }

  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => true

  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
 

  # before saving to the DB
  before_save :encrypt_password

  # 
  # Method : has_password?
  # 
  # Returns TRUE if the encrypted form of input password
  # matches the stored encrypted password.
  #
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  #
  # Method : authenticate
  #
  # Returns the user corresponding to the input email only
  # if the given password is correct.  Returns Null otherwise.
  #
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  private

    #
    # Function : encrypt_password
    #
    # Creates a salt and also a password for user.
    # Used before storing the password in DB
    #
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    #
    # Function : encrypt
    #
    # Returns an encrypted form of the input string using
    # the current user's salt
    #
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    #
    # Function : make_salt
    #
    # Returns a salt value
    #
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    #
    # Function : secure_hash
    #
    # Returns an encrypted input string using SHA2
    #
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
   
end
