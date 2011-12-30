class SessionsController < ApplicationController

	def create
		if administrator = Administrator.authenticate(params[:email], params[:password])
			session[:administrator_id] = administrator.id
			redirect_to stats_path, :notice => "Logged in successfully"
		else
			flash.now[:alert] = "Invalid login/password combination"
			render :action => 'new'
		end
	end
	
	def destroy
		reset_session
		redirect_to login_path, :notice => "You successfully logged out"
	end

end
