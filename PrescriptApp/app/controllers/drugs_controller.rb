class DrugsController < ApplicationController


	def index
		@drugs = Drug.all 
		#Drug.find_by_sql "SELECT d.generic_name, d.price FROM Drug d;"
	end

end
