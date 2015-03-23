class DrugsController < ApplicationController
	before_action :authenticate_user!


	def index
		@drugs = Drug.all
		@drug = Drug.new
		#@drugs = Drug.find_by_sql("SELECT * FROM Drug")
		@result = Drug.connection.select_all("SELECT * FROM Drug")
		#@result = Drug.connection.select_all("SELECT * FROM prescription")
		

		#Drug.find_by_sql "SELECT d.generic_name, d.price FROM Drug d;"
	end


	############################# Pharmacist Queries ################################


	def qPh1
		@result = Drug.connection.select_all("select Pr.PrescriptID from Prescription Pr, Doctor D where Pr.LicenseNum=D.LicenseNum")
		render "index"
	end

	# ADD VARIABLE FOR PRESCRIPT ID
	# USE EXECUTE, NOT CONNECTION!
	 def qPh2
		# Drug.connection.select_all("update Prescription set ReadyForPickUp=1 where PrescriptID ='3456' AND ReadyForPickup=0")
	 	render "index"
	 end

	# ADD VARIABLE FOR CARECARDNUM
	 def qPh3
		#@result = Drug.connection.select_all("select Pr.date_prescribed,I.GenericName,Pr.Refills,Pr.Dosage from Prescription Pr, Patient P, Includes I where Pr.CareCardNum=P.CareCardNum AND I.PrescriptID=Pr.PrescriptID AND Pr.CareCardNum=1234567890 Order By Pr.date_prescribed")
		render "index"
	 end

	 def qPh4
	 	@result = Drug.connection.select_all("select I.GenericName, Pr.Dosage from Prescription Pr, Patient P, Includes I where Pr.PrescriptID=I.PrescriptID AND Pr.CareCardNum=P.CareCardNum AND Pr.date_prescribed=curdate()")
	 	render "index"
	 end

	 # ADD VARIABLE FOR PRESCRIPT ID
	 # USE EXECUTE, NOT CONNECTION!
	 def qPh5
		# Drug.connection.select_all("update Prescription set Refills=Refills-1 where PrescriptID='3456' AND Refills > 0")
		render "index"
	 end

	 ############################# Patient Queries ################################

	 # ADD VARIABLES FOR firstname, lastname, age, weight, height, address, phonenumber, CareCardNum
	 # USE EXECUTE, NOT CONNECTION!
	 def qPa1
		# Drug.connection.select_all("update Patient set FirstName = 'blabla', LastName = 'blabla', Age = 'blabla', Weight = 'blabla', Height = 'blabla', Address = 'blabla', PhoneNumber = 'blabla' where P.CareCardNum LIKE '1234567890'")
		render "index"
	 end

	 def qPa2
	 	@result = Drug.connection.select_all("select * from Pharmacy P where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing")
		render "index"
	 end

	 def qPa3
	 	@result = Drug.connection.select_all("select * from Pharmacy P where curtime() between P.WeekendHoursOpening and P.WeekendHoursClosing")
		render "index"
	 end

	 # ADD VARIABLES FOR start and end time, doctorid, patient id
	 # USE EXECUTE, NOT CONNECTION!
	 def qPa4
	 	# Drug.connection.select_all("insert into TimeBlock values ('2874-06-07', '12:30:00', '15:30:00')")
	 	# Drug.connection.select_all("insert into MakesAppointmentWith values (curdate(), curtime(), '1232131241', '2874-06-07', '12:30:00', '15:30:00', '1234567890')")
		render "index"
	 end

	 # ADD VARIABLES FOR start and end time, patient id
	 def qPa5
	 	# Drug.connection.select_all("delete from MakesAppointmentWith where CareCardNum = '1234567890' and TimeBlockDate = '2015-04-03' and StartTime = '09:00:00'")
		render "index"
	 end

	# ADD VARIABLES
	# USE EXECUTE, NOT CONNECTION!
	 def qPa6
	 	# @result = Drug.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(D.FirstName, " ", D.LastName) as "Doctor", CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on " from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '1234567890'")
	 	# @result = Drug.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(D.FirstName, " ", D.LastName) as "Doctor", CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on " from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '1234567890' and MakeApptW.TimeBlockDate = '2015-04-03'")
	 	# @result = Drug.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(D.FirstName, " ", D.LastName) as "Doctor", CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on " from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '1234567890' and MakeApptW.StartTime >=  '09:00:00'  and MakeApptW.StartTime <=  '11:00:00'")
		render "index"
	 end

	 # ADD VARIABLES FOR genericName
	 def qPa7
	 	# Drug.connection.select_all("select dGenericName from InteractsWith where iGenericName like '%Ibuprofen%'")
		render "index"
	 end

	 # ADD VARIABLES FOR prescriptionID
	 def qPa8
	 	# Drug.connection.select_all("select distinct IW.iBrandName as "Brand name" , IW.iGenericName as "Generic name" from Prescription P, InteractsWith IW, Includes I, Drug D1, Drug D2 where 	P.PrescriptID LIKE '0001' and P.PrescriptID = I.PrescriptID and I.BrandName = D1.BrandName and I.GenericName = D1.GenericName and IW.dBrandName = D1.BrandName and IW.dGenericName = D1.GenericName and IW.iBrandName != D1.BrandName and IW.iGenericName != D1.GenericName")
		render "index"
	 end

	 def qPa9
	 	@result = Drug.connection.select_all("select * from Prescription where ReadyForPickup=1")
		render "index"
	 end

	 # ADD VARIABLES FOR CareCardNumber
	 def qPa10
	 	# @result = Drug.connection.select_all("select distinct Pr.PrescriptID as "Prescription ID", (Pr.date_prescribed) as "Date prescribed", CONCAT(D.FirstName, " ", D.LastName) as "Prescribed by", CONCAT (Dr.BrandName, " ", Dr.GenericName) as Drug, Pr.dosage as "Drug dosage",  Pr.refills as "Refills" from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr where 	P.CareCardNum LIKE '1234567890' and P.CareCardNum = Pr.CareCardNum and Pr.LicenseNum = D.LicenseNum and I.PrescriptID = Pr.PrescriptID and I.BrandName = Dr.BrandName and I.GenericName = Dr.GenericName and Pr.refills > 0 order by Pr.date_prescribed desc")
		render "index"
	 end

	# ADD VARIABLES FOR CareCardNumber
	 def qPa11
	 	# @result = Drug.connection.select_all("select distinct Pr.PrescriptID as "Prescription ID", (Pr.date_prescribed) as "Date prescribed", CONCAT(D.FirstName, " ", D.LastName) as "Prescribed by", CONCAT (Dr.BrandName, " ", Dr.GenericName) as Drug, Pr.dosage as "Drug dosage",  Pr.refills as "Refills" from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr where 	P.CareCardNum LIKE '1234567890' and P.CareCardNum = Pr.CareCardNum and Pr.LicenseNum = D.LicenseNum and I.PrescriptID = Pr.PrescriptID and I.BrandName = Dr.BrandName and I.GenericName = Dr.GenericName and Pr.refills = 0 order by Pr.date_prescribed desc")
		render "index"
	 end

 	############################# Doctor Queries ################################

 	# ADD VARIABLES
 	# USE EXECUTE, NOT CONNECTION!
	 def qD1
	 	#Drug.connection.select_all("update Doctor set FirstName = 'bla', LastName = 'bla', Address = 'bla', PhoneNumber = 7789877680, Type = "Super cool doctor type" where LicenseNum = '1232131241'")
		render "index"
	 end

 	# ADD VARIABLES
 	# USE EXECUTE, NOT CONNECTION!
	 def qD2
	 	# @result = Drug.connection.select_all("insert into Prescription values ('doctorIDvariable','?','?' ,'?' ,'?' , 0, NOW())")
		render "index"
	 end

	 def qD3
	 	@result = Drug.connection.select_all("select * from Pharmacy P where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing")
		render "index"
	 end

	 def qD4
	 	@result = Drug.connection.select_all("select * from Pharmacy P where curtime() between P.WeekendHoursOpening and P.WeekendHoursClosing")
		render "index"
	 end

 	# ADD VARIABLES
	 def qD5
	 	#@result = Drug.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(P.FirstName, " ", P.LastName) as "Patient", CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on " from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and D.LicenseNum  = '1232131241' order by MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate")
		render "index"
	 end

	# ADD VARIABLES
	 def qD6
	 	#@result = Drug.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(P.FirstName, " ", P.LastName) as "Patient", CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on " from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and D.LicenseNum  = '1232131241' and MakeApptW.TimeBlockDate = '2015-04-03'")
		render "index"
	 end

	 # ADD VARIABLES
	 def qD7
	 	#@result = Drug.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(P.FirstName, " ", P.LastName) as "Patient", CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on " from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and D.LicenseNum  = '1232131241' and MakeApptW.StartTime >=  '09:00:00'  and MakeApptW.StartTime <=  '11:00:00'")
		render "index"
	 end

	 # ADD VARIABLES
	 def qD8
	 	#@result = Drug.connection.select_all("select * from Patient where CareCardNum=999")
		render "index"
	 end

	 # MUST MAKE SURE CAN ONLY ACCESS OWN PATIENTS
 	 # ADD VARIABLES
	 def qD9
	 	#@result = Drug.connection.select_all("select Pr.PrescriptID from Prescription Pr, Doctor D where Pr.LicenseNum=D.LicenseNum")
		render "index"
	 end

	 # MUST MAKE SURE CAN ONLY ACCESS OWN PATIENTS
	 # ADD VARIABLES
	 def qD10
	 	#@result = Drug.connection.select_all("select I.GenericName from Prescription Pr, Patient P, Includes I where P.CareCardNum= '1234 456 789' AND Pr.CareCardNum=P.CareCardNum AND I.PrescriptID=Pr.PrescriptID")
		render "index"
	 end

	 # ADD VARIABLES
	 def qD11
	 	#@result = Drug.connection.select_all("select distinct Pr.PrescriptID as "Prescription ID", (Pr.date_prescribed) as "Date prescribed", CONCAT(D.FirstName, " ", D.LastName) as "Prescribed by", CONCAT (Dr.BrandName, " ", Dr.GenericName) as Drug, Pr.dosage as "Drug dosage" from Patient P, Prescription Pr, Doctor D, Pharmacy Pm, Includes I, Drug Dr where P.CareCardNum LIKE '1234567890' and P.CareCardNum = Pr.CareCardNum and Pr.LicenseNum = D.LicenseNum and I.PrescriptID = Pr.PrescriptID and I.BrandName = Dr.BrandName and I.GenericName = Dr.GenericName and Pr.refills = 0 order by Pr.date_prescribed desc")
		render "index"
	 end

	 # ATTRIBUTE NAMES DO NOT WORK
	 def qD12
	 	#@result = Drug.connection.select_all("select I.iGenericName from InteractsWith I, Drug D where D.GenericName=I.dGenericName AND D.CompanyName=I.dCompanyName")
		render "index"
	 end

	 def qD13
	 	@result = Drug.connection.select_all("select M.DateMade from MakesAppointmentWith M, Doctor D where D.LicenseNum=M.LicenseNum")
		render "index"
	 end

	# ADD VARIABLES
	 def qD14
	 	# @result = Drug.connection.select_all("select Pr.PrescriptID, CONCAT(P.FirstName, ' ', P.LastName) as PatientName, CONCAT (Dr.BrandName, ' ', Dr.GenericName) as Drug, CONCAT(Pm.Address, ', ', Pm.Name) as PharmacyDescription 
			# 								from Prescription Pr, Doctor D, Patient P, Pharmacy Pm, OrderedFrom O, Includes I, Drug Dr
			# 								where 	Pr.LicenseNum = D.LicenseNum and
			# 										Pr.CareCardNum = P.CareCardNum and 
			# 										O.PrescriptID = Pr.PrescriptID and 
			# 										O.PharmacyAddress = Pm.Address and 
			# 										I.PrescriptID = Pr.PrescriptID and
			# 										I.BrandName = Dr.BrandName and
			# 										I.GenericName = Dr.GenericName and
			# 										D.LicenseNum LIKE '1232131241'")
		render "index"
	 end

	 def qD15
	 	@result = Drug.connection.select_all("select CONCAT(Dr.BrandName, ' ', Dr.GenericName) as 'Drug', AVG(P.Refills) as 'Average number of refills'
											from Prescription P, Drug Dr, Includes I
											where P.PrescriptID = I.PrescriptID and 
													I.BrandName = Dr.BrandName and 
													I.GenericName = Dr.GenericName
											group by Dr.BrandName, Dr.GenericName
											order by AVG(P.Refills) desc, Dr.BrandName, Dr.GenericName")
		render "index"
	 end

	 #ADD VARIABLES
	def qD16
	 	# @result = Drug.connection.select_all("select Pa.CareCardNum, Pa.FirstName
			# 								from Patient Pa
			# 								Where NOT EXISTS
			# 								     (Select *
			# 								      from Drug D
			# 								      Where D.CompanyName LIKE 'Pfizer'
			# 								      AND NOT EXISTS
			# 								      (Select * 
			# 								            From Prescription P, Includes I
			# 								            WHERE P.PrescriptID = I.prescriptID and 
			# 								            		I.BrandName = D.BrandName and
			# 								            		P.CareCardNum = Pa.CareCardNum))")
		render "index"
	 end



end
