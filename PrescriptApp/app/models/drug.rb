class Drug  < ActiveRecord::Base 
	
#	def self.prices
#		Drug.find_by_sql "SELECT d.generic_name, d.price FROM Drug d;"
#	end

	self.table_name = "Drug"

end
