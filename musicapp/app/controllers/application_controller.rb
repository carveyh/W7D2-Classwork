class ApplicationController < ActionController::Base
	skip_before_action :verify_authenticity_token
	helper_method :current_user #exposes this method to views layer, so it can check if there is a current user. Access user attributes for display / logic, and render login/logout based on whether we have a current user.

	def login!(user)
		session[:session_token] = user.reset_session_token!
	end

	def current_user
		@current_user ||= User.find_by(session_token: session[:session_token])
	end

	def logged_in?
		!!@current_user
	end

	def logout! #QQQ logout! should not take an argument, correct? Logout should specifically logout the current_user which should not require an argument.
		current_user.reset_session_token if logged_in?
		session[:session_token] = nil
		@current_user = nil
	end
end
