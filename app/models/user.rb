# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
	has_many :messages
	has_many :relations
	default_scope :order => 'created_at ASC'
end
