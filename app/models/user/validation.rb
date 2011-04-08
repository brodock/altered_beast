class User

  before_validation :normalize_login_and_email
  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :scope => :site_id

  before_create :set_first_user_as_admin
  # validates_email_format_of :email, :message=>"is invalid"
  validates_uniqueness_of :openid_url, :case_sensitive => false, :allow_nil => true

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :bio, 
    :openid_url, :display_name, :website

  protected
    
  def using_openid
    self.openid_url.blank? ? false : true
  end
    
  def password_required?    
    return false if using_openid
    encrypted_password.blank? || password.present?
  end
  
  def set_first_user_as_admin
    self.admin = true if site && site.users.size.zero?
  end
  
  def normalize_login_and_email
    login.downcase! && login.strip! if login
    email.downcase! if email
    return true
  end
end
