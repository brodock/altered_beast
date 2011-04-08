class User
  devise :database_authenticatable, :registerable, :recoverable, 
         :rememberable, :confirmable, :validatable, 
         :encryptable, :encryptor => :restful_authentication_sha1
  
end
