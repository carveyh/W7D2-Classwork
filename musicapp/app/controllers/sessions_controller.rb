class SessionsController < ApplicationController
	def new #display login page
		@user = User.new
		render :new
	end

	def create #attempt login
		email = params[:user][:email]
		password = params[:user][:password]
		@user = User.find_by_credentials(email, password)

		if @user #if user exists...
			# debugger
			login!(@user) #generate new session_token for @user, and save it to session's session_token so they match
			redirect_to user_url(@user) #show userpage.
		
		else #if login not successful, reattempt login
			@user = User.new(email: email)
			render :new
		end

	end

	def destroy #logout
		logout!
		redirect_to new_session_url
	end

end