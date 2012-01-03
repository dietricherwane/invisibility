class Counter < ActiveRecord::Base
	default_scope :order => 'sms_number DESC'
end
