class Table < ActiveRecord::Base

		self.table_name = "tables"

		attr_accessor :identity
		attr_accessor :var1

end
