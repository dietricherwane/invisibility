require 'digest'

class Administrator < ActiveRecord::Base
	attr_accessor :password
	validates :email, :uniqueness => true,
						:length => { :within => 5..50 },
						:format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
	validates :password, :confirmation => true
	
	before_save :encrypt_new_password
	
	def self.authenticate(email, password)
		administrator = find_by_email(email)
		return administrator if administrator && administrator.authenticated?(password)
	end
	
	def authenticated?(password)
		self.hashed_password == encrypt(password)
	end
	
	protected
	def encrypt_new_password
		return if password.blank?
		self.hashed_password = encrypt(password)
	end
	
	def password_required?
		hashed_password.blank? || password.present?
	end
	
	def encrypt(string)
		Digest::SHA1.hexdigest(string)
	end
	
end
