class UsersController < ApplicationController
	def new #display signup page
		@user = User.new
		render :new
	end

	def create #attempt signup
		@user = User.new(user_params)
		debugger
		if @user.save #if user successfully created...
			login!(@user) #generate new session token for user and match the session's session token to that.
			redirect_to user_url(@user) #show userpage.
		else #if signup not successful, reattempt signup
			@user = User.new(email: user_params[:email])
			render :new
		end
	end

	def show #display specific userpage
		@user = User.find_by(id: params[:id])
		if @user #if user found, show.
			render :show
		else #if user not found, display login page
			redirect_to new_session_url
		end
	end

	def user_params
		params.require(:user).permit(:email, :password, :session_token)
	end
end