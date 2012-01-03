class SessionsController < ApplicationController

	def create
		if administrator = Administrator.authenticate(params[:email], params[:password])
			session[:administrator_id] = administrator.id
			redirect_to dashboard_path, :notice => "Logged in successfully"
		else
			flash.now[:alert] = "Invalid login/password combination"
			render :action => 'new', :layout => false
		end
	end
	
	def destroy
		reset_session
		redirect_to login_path, :notice => "You successfully logged out"
	end
	
	def new
		render :layout => false
	end

end
