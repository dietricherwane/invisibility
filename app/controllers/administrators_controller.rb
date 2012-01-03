class AdministratorsController < ApplicationController

	before_filter :authenticate
	
	def new
		@administrator = Administrator.new
		@posts = User.paginate(:page => params[:page], :per_page => 4)
	end
	
	def create
		@administrator = Administrator.new(params[:administrator])
		if @administrator.save
			redirect_to dashboard_path, :notice => 'User successfully added.'
		else
			render :action => 'new'
		end
	end
	
	def edit
		@administrator = Administrator.find(params[:id])
	end
	
	def update
		@administrator = Administrator.find(params[:id])
		if @administrator.update_attributes(params[:administrator])
			redirect_to dashboard_path, :notice => 'Updated user information successfully.'
		else
			render :action => 'edit'
		end
	end
	
end
