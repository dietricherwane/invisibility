class Parameter < ActiveRecord::Base
	validates :break_relationship, :registration, :area, :informations, :initiate_relationship, :accept, :presence => true
end
