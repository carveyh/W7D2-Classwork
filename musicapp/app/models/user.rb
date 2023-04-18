# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
	validates :email, :session_token, presence: true, uniqueness: true
	validates :password_digest, presence: true
	validates :password, length: { minimum: 6 }, allow_nil: true

	before_validation :ensure_session_token

	attr_reader :password

	def self.find_by_credentials(email, password)
		user = User.find_by(email: email)
		if user && user.is_password?(password) #Ruby && is short circuit, so if user.nil? then will not evaluate right side, will not trigger NoMethodError for nil:NilClass
			user
		else
			nil
		end
	end

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def is_password?(password)
		password_obj = BCrypt::Password.new(self.password_digest)
		password_obj.is_password?(password)
	end

	def reset_session_token!
		self.session_token = generate_unique_session_token
		self.save!
		self.session_token
	end

	private

	def generate_unique_session_token
		# debugger
		possible_session_token = SecureRandom::urlsafe_base64
		while User.find_by(session_token: possible_session_token) 
			possible_session_token = SecureRandom::urlsafe_base64
		end
		possible_session_token
	end

	def ensure_session_token
		self.session_token ||= generate_unique_session_token #QQQ: How come this doesn't work for implicit self (omit self.)?
	end
end
