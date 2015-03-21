class DrugsController < ApplicationController


	def index
		@drugs = Drug.all
		#@drugs = Drug.find_by_sql("SELECT * FROM Drug")
		@result = Drug.connection.select_all("SELECT * FROM Drug")
		#Drug.find_by_sql "SELECT d.generic_name, d.price FROM Drug d;"
	end

end
