class DrugsController < ApplicationController
	before_action :authenticate_user!


	def index
		@drugs = Drug.all
		#@drugs = Drug.find_by_sql("SELECT * FROM Drug")
		#@result = Drug.connection.select_all("SELECT * FROM Drug")
		@result = Drug.connection.select_all("SELECT * FROM prescription")

		#Drug.find_by_sql "SELECT d.generic_name, d.price FROM Drug d;"
	end

	def select
		@drugs = Drug.all

		@result = Drug.connection.select_all("SELECT D.generic_name, p.id FROM Drug D, prescription p WHERE D.generic_name = p.generic_name")
		render "index"
	end

	def show
	end


end
