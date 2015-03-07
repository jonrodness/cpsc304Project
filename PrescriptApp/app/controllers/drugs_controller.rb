class DrugsController < ApplicationController


	def index
		@drugs = Drug.all
	end

end
