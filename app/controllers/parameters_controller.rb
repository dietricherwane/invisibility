class ParametersController < ApplicationController

	before_filter :authenticate	
	
	def edit
		@parameters = Parameter.first
	end
	
	def update
		Parameter.first.update_attributes(params[:parameter])
		redirect_to edit_parameter_path(Parameter.first.id), :notice => 'Updated parameters.'
	end
	
end
