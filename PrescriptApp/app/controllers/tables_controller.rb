class TablesController < ApplicationController
	before_action :get_user_attributes

	def index
		@table = Table.new
		@table.save

		#@table.identity = 1
		#@table.update_attribute(:identity, 1)
		@result = Table.connection.select_all("SELECT * FROM Drug")
		@license = current_user.license_num
		Rails.logger.info ">>>>>>>>> #{@license} <<<<<<<"

	end

	def update
	end

############################# Pharmacist Queries ################################

	# View prescriptions prescribed by doctor
	def qPh1
		@result = Table.connection.select_all("select Pr.PrescriptID from Prescription Pr, Doctor D where Pr.LicenseNum=D.LicenseNum")
		render "index"
	end

	# Update prescription status
		# USE VARIABLE FOR PRESCRIPT ID
		# USE EXECUTE, NOT CONNECTION!
	 def qPh2
		# Table.connection.select_all("update Prescription set ReadyForPickUp=1 where PrescriptID ='3456' AND ReadyForPickup=0")
	 	render "index"
	 end

	 # View past prescriptions
		 # ADD VARIABLE FOR CARECARDNUM
	 def qPh3
	 	ccNum = params[:ccNum]
		#@result = Table.connection.select_all("select Pr.date_prescribed,I.GenericName,Pr.Refills,Pr.Dosage from Prescription Pr, Patient P, Includes I where Pr.CareCardNum=P.CareCardNum AND I.PrescriptID=Pr.PrescriptID AND Pr.CareCardNum=1234567890 Order By Pr.date_prescribed")
		render "index"
	 end

	 # Print out a list of prescriptions filled that day
	 def qPh4
	 	@result = Table.connection.select_all("select I.GenericName, Pr.Dosage from Prescription Pr, Patient P, Includes I where Pr.PrescriptID=I.PrescriptID AND Pr.CareCardNum=P.CareCardNum AND Pr.date_prescribed=curdate()")
	 	render "index"
	 end

	 # Reduce the refill number of a patient’s prescription
		 # USE VARIABLE FOR PRESCRIPT id
		 # USE EXECUTE, NOT CONNECTION!
	 def qPh5
	 	prescription = params[:prescription]
		# Table.connection.select_all("update Prescription set Refills=Refills-1 where PrescriptID='3456' AND Refills > 0")
		render "index"
	 end

	 ############################# Patient Queries ################################

	 # ADD VARIABLES FOR firstname, lastname, age, weight, height, address, phonenumber, CareCardNum
	 # USE EXECUTE, NOT CONNECTION!
	 # def qPa1
	 # 	#@table = Table.find_by identity: 1
	 # 	var1 = params[:var1]
	 # 	@table = Table.new
	 # 	#@table.update(table_params)
	 # 	@result = Table.connection.select_all("select * from " + var1)
		# # Table.connection.select_all("update Patient set FirstName = 'blabla', LastName = 'blabla', Age = 'blabla', Weight = 'blabla', Height = 'blabla', Address = 'blabla', PhoneNumber = 'blabla' where P.CareCardNum LIKE '1234567890'")
		# render "index"
	 # end

	 # Update personal information
		 # USE VARIABLES FOR firstname, lastname, age, weight, height, address, phonenumber, CareCardNum
		 # USE EXECUTE, NOT CONNECTION!
	 def qPa1
	 	pFName = params[:pFName]
	 	pLName = params[:pLName]
	 	pAge = params[:pAge]
	 	pWeight = params[:pWeight]
	 	pHeight = params[:pHeight]
	 	pAddress = params[:pAddress]
	 	pPhoneNum = params[:pPhoneNum]
	 	pCCNum = params[:pCCNum]
	 	# Table.connection.select_all("update Patient set FirstName = 'blabla', LastName = 'blabla', Age = 'blabla', Weight = 'blabla', Height = 'blabla', Address = 'blabla', PhoneNumber = 'blabla' where P.CareCardNum LIKE '1234567890'")
	 	render "index"
	 end

	 # Pharmacies that are currently open: Weekday
	 def qPa2
	 	@result = Table.connection.select_all("select * from Pharmacy P where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing")
		render "index"
	 end

	 # Pharmacies that are currently open: Weekend
	 def qPa3
	 	@result = Table.connection.select_all("select * from Pharmacy P where curtime() between P.WeekendHoursOpening and P.WeekendHoursClosing")
		render "index"
	 end

	 # Make an Appointment
		 # USE VARIABLES FOR start and end time, doctorid
		 # ADD VARIABLE FOR ccNum (from current_user)
		 # USE EXECUTE, NOT CONNECTION!
	 def qPa4
	 	date = params[:date]
	 	sTime = params[:sTime]
	 	eTime = params[:eTime]
	 	license = params[:license]
	 	# Table.connection.select_all("insert into TimeBlock values ('2874-06-07', '12:30:00', '15:30:00')")
	 	# Table.connection.select_all("insert into MakesAppointmentWith values (curdate(), curtime(), '1232131241', '2874-06-07', '12:30:00', '15:30:00', '1234567890')")
		render "index"
	 end

	 # Cancel an Appointment
		 # USE VARIABLES FOR start and end time
		 # ADD VARIABLE FOR ccNum (from current_user)
		 # USE EXECUTE, NOT CONNECTION!
	 def qPa5
	 	date = params[:date]
	 	sTime = params[:sTime]
	 	# Table.connection.select_all("delete from MakesAppointmentWith where CareCardNum = '1234567890' and TimeBlockDate = '2015-04-03' and StartTime = '09:00:00'")
		render "index"
	 end

	# View all upcoming appointments
		# ADD VARIABLE for ccNum
	 def qPa6a
	 	# @result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(D.FirstName, " ", D.LastName) as "Doctor", CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on " from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '1234567890'")
		render "index"
	 end

	# View upcoming appointments by date
		# USE VARIABLE FOR date
	 	# ADD VARIABLE for ccNum
	 def qPa6b
	 	date = params[:date]
	 	# @result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(D.FirstName, " ", D.LastName) as "Doctor", CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on " from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '1234567890' and MakeApptW.TimeBlockDate = '2015-04-03'")
		render "index"
	 end
	
	# View upcoming appointments by time	
		# USE VARIABLES FOR start and end time
		# ADD VARIABLE for ccNum
	 def qPa6c
	 	sTime = params[:sTime]
	 	eTime = params[:eTime]
	 	# @result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(D.FirstName, " ", D.LastName) as "Doctor", CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on " from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '1234567890' and MakeApptW.StartTime >=  '09:00:00'  and MakeApptW.StartTime <=  '11:00:00'")
		render "index"
	 end

	 # Check Drug Interactions
	 	# USE VARIABLE FOR drug
	 def qPa7
	 	drug = params[:drug]
	 	# Table.connection.select_all("select dGenericName from InteractsWith where iGenericName like '%Ibuprofen%'")
		render "index"
	 end

	 # Check Interactions for this prescriptionID
	 	# USE VARIABLES FOR prescription
	 	# do we need variable for patientID?
	 def qPa8
	 	prescription = params[:prescription]
	 	# Table.connection.select_all("select distinct IW.iBrandName as "Brand name" , IW.iGenericName as "Generic name" from Prescription P, InteractsWith IW, Includes I, Drug D1, Drug D2 where 	P.PrescriptID LIKE '0001' and P.PrescriptID = I.PrescriptID and I.BrandName = D1.BrandName and I.GenericName = D1.GenericName and IW.dBrandName = D1.BrandName and IW.dGenericName = D1.GenericName and IW.iBrandName != D1.BrandName and IW.iGenericName != D1.GenericName")
		render "index"
	 end

	 # View Prescription Status
	 def qPa9
	 	@result = Table.connection.select_all("select * from Prescription where ReadyForPickup=1")
		render "index"
	 end

	 # Generate Report: Current Prescription
	 	# ADD VARIABLE FOR CCNum
	 def qPa10
	 	# @result = Table.connection.select_all("select distinct Pr.PrescriptID as "Prescription ID", (Pr.date_prescribed) as "Date prescribed", CONCAT(D.FirstName, " ", D.LastName) as "Prescribed by", CONCAT (Dr.BrandName, " ", Dr.GenericName) as Drug, Pr.dosage as "Drug dosage",  Pr.refills as "Refills" from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr where 	P.CareCardNum LIKE '1234567890' and P.CareCardNum = Pr.CareCardNum and Pr.LicenseNum = D.LicenseNum and I.PrescriptID = Pr.PrescriptID and I.BrandName = Dr.BrandName and I.GenericName = Dr.GenericName and Pr.refills > 0 order by Pr.date_prescribed desc")
		render "index"
	 end

	 # Generate Report: Previous Prescription
	 	# ADD VARIABLE FOR CCNum
	 def qPa11
	 	# @result = Table.connection.select_all("select distinct Pr.PrescriptID as "Prescription ID", (Pr.date_prescribed) as "Date prescribed", CONCAT(D.FirstName, " ", D.LastName) as "Prescribed by", CONCAT (Dr.BrandName, " ", Dr.GenericName) as Drug, Pr.dosage as "Drug dosage",  Pr.refills as "Refills" from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr where 	P.CareCardNum LIKE '1234567890' and P.CareCardNum = Pr.CareCardNum and Pr.LicenseNum = D.LicenseNum and I.PrescriptID = Pr.PrescriptID and I.BrandName = Dr.BrandName and I.GenericName = Dr.GenericName and Pr.refills = 0 order by Pr.date_prescribed desc")
		render "index"
	 end

 	############################# Doctor Queries ################################

 	# Update personal information
	 	# ADD VARIABLES
	 	# DOES NOT WORK YET
	 	# USE EXECUTE, NOT CONNECTION!
	 def qD1
	 	dFName = params[:dFName]
	 	dLName = params[:dLName]
	 	dAddress = params[:dAddress]
	 	dPhoneNum = params[:dPhoneNum]
	 	dSpecialty =  params[:dSpecialty]
	 	dLicenseNum = current_user.license_num
	 	Table.connection.select_all("update Doctor
						 			set
										FirstName = '" + dFName + "',
										LastName = '" + dLName + "',
										Address = '" + dAddress + "',
										PhoneNumber = " + dPhoneNum +",
										Type = '" + dSpecialty = "'
									where
										LicenseNum = '" + dLicenseNum + "'")
	 	@result = Table.connection.select_all("select *
									from Doctor
									where
										LicenseNum = '" + dLicenseNum + "'")
		render "index"
	 end

	 # Prescribe a Drug
	 	# USE VARIABLES
	 	# DOES NOT WORK YET
	 	# ARE THESE THE CORRECT VARIABLES?
	 	# USE EXECUTE, NOT CONNECTION!
	 def qD2
	 	prescription  = params[:prescription]
	 	refills = params[:refills]
	 	dosage = params[:dosage]
	 	ccNum = params[:ccNum]
	 	dLicenseNum = current_user.license_num
	 	@result = Table.connection.select_all("insert into Prescription values ('" + dLicenseNum + "','" + prescription + "','" + refills + "' ,'" + dosage + "' ,'" + ccNum + "' , 0, NOW())")
		render "index"
	 end

 	# Pharmacies that are currently open: Weekday
	 def qD3
	 	@table = Table.new
	 	@result = Table.connection.select_all("select * from Pharmacy P where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing")
		render "index"
	 end
 	
 	# Pharmacies that are currently open: Weekend
	 def qD4
	 	@table = Table.new
	 	@result = Table.connection.select_all("select * from Pharmacy P where curtime() between P.WeekendHoursOpening and P.WeekendHoursClosing")
		render "index"
	 end

	# View Appointments for picked date and time
	 	# ADD DOCTOR LICENSE VARIABLE
	 	# DOES THIS NEED MORE PARAMS?
	 def qD5
	 	@result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
														CONCAT(P.FirstName, ' ', P.LastName) as 'Patient',  
													CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on '
												from MakesAppointmentWith MakeApptW, Doctor D, Patient P
												where MakeApptW.LicenseNum = D.LicenseNum and
														MakeApptW.CareCardNum = P.CareCardNum and
														D.LicenseNum  = '1232131241'
												order by MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate")
		render "index"
	 end

	 # View Appointments on a certain date
	 	# USE VARIABLES
	 def qD6

	 	date = params[:date]
	 	@result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
														CONCAT(P.FirstName, ' ', P.LastName) as 'Patient',  
													CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on '
												from MakesAppointmentWith MakeApptW, Doctor D, Patient P
												where MakeApptW.LicenseNum = D.LicenseNum and
														MakeApptW.CareCardNum = P.CareCardNum and
														D.LicenseNum  = '1232131241'
														MakeApptW.TimeBlockDate = '2015-04-03'")
		render "index"
	 end

	 # View Appointments during a certain time
	 	# USE VARIABLES
	 def qD7
	 	sTime = params[:sTime]
	 	eTime = params[:eTime]
	 	#@result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(P.FirstName, " ", P.LastName) as "Patient", CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on " from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and D.LicenseNum  = '1232131241' and MakeApptW.StartTime >=  '09:00:00'  and MakeApptW.StartTime <=  '11:00:00'")
		render "index"
	 end

	 # View patient information
	 	# USE VARIABLES
	 	# DO WE WANT TO LIMIT THIS TO ONLY THE PATIENTS THIS DOCTOR SEES?
	 def qD8
	 	ccNum = params[:ccNum]
	 	#@result = Table.connection.select_all("select * from Patient where CareCardNum=999")
		render "index"
	 end

	 # View a list of previous prescriptions for a certain patient
		 # MUST MAKE SURE CAN ONLY ACCESS OWN PATIENTS
	 	 # USE VARIABLES
	 def qD9
	 	ccNum = params[:ccNum]
	 	#@result = Table.connection.select_all("select Pr.PrescriptID from Prescription Pr, Doctor D where Pr.LicenseNum=D.LicenseNum")
		render "index"
	 end

	 # View a list of previous drugs prescribed to a certain patient
		 # MUST MAKE SURE CAN ONLY ACCESS OWN PATIENTS
		 # USE VARIABLES
	 def qD10
	 	ccNum = params[:ccNum]
	 	#@result = Table.connection.select_all("select I.GenericName from Prescription Pr, Patient P, Includes I where P.CareCardNum= '1234 456 789' AND Pr.CareCardNum=P.CareCardNum AND I.PrescriptID=Pr.PrescriptID")
		render "index"
	 end

	 # Check if a certain drug was taken in the past by a certain patient
	 	# USE VARIABLES
	 def qD11
	 	ccNum = params[:ccNum]
	 	brandName = params[:brandName]
	 	genericName = params[:genericName]
	 	#@result = Table.connection.select_all("select distinct Pr.PrescriptID as "Prescription ID", (Pr.date_prescribed) as "Date prescribed", CONCAT(D.FirstName, " ", D.LastName) as "Prescribed by", CONCAT (Dr.BrandName, " ", Dr.GenericName) as Drug, Pr.dosage as "Drug dosage" from Patient P, Prescription Pr, Doctor D, Pharmacy Pm, Includes I, Drug Dr where P.CareCardNum LIKE '1234567890' and P.CareCardNum = Pr.CareCardNum and Pr.LicenseNum = D.LicenseNum and I.PrescriptID = Pr.PrescriptID and I.BrandName = Dr.BrandName and I.GenericName = Dr.GenericName and Pr.refills = 0 order by Pr.date_prescribed desc")
		render "index"
	 end

	 # View possible drug interactions
	 	# NOT SURE ABOUT THESE ATTRIBUTES...
	 def qD12
	 	iBrandName = params[:iBrandName]
	 	iGenericName = params[:iGenericName]
	 	dBrandName = params[:dBrandName]
	 	dGenericName = params[:dGenericName]
	 	#@result = Table.connection.select_all("select I.iGenericName from InteractsWith I, Drug D where D.GenericName=I.dGenericName AND D.CompanyName=I.dCompanyName")
		render "index"
	 end

	 # View patient's past appointments
	 	# DON'T WE NEED THE CARE CARD NUMBER AS A PARAMETER?
	 def qD13
	 	ccNum = params[:ccNum]
	 	@result = Table.connection.select_all("select M.DateMade from MakesAppointmentWith M, Doctor D where D.LicenseNum=M.LicenseNum")
		render "index"
	 end

	 # Generate a report about which prescriptions a doctor has previously prescribed...
	 	# ADD Doctorlicense VARIABLE from current_user
	 def qD14
	 	# @result = Table.connection.select_all("select Pr.PrescriptID, CONCAT(P.FirstName, ' ', P.LastName) as PatientName, CONCAT (Dr.BrandName, ' ', Dr.GenericName) as Drug, CONCAT(Pm.Address, ', ', Pm.Name) as PharmacyDescription 
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

	 # Show the average number of refills for a certain drug
	 	# DONT WE NEED A DRUG VARIABLE?
	 def qD15
	 	@result = Table.connection.select_all("select CONCAT(Dr.BrandName, ' ', Dr.GenericName) as 'Drug', AVG(P.Refills) as 'Average number of refills'
											from Prescription P, Drug Dr, Includes I
											where P.PrescriptID = I.PrescriptID and 
													I.BrandName = Dr.BrandName and 
													I.GenericName = Dr.GenericName
											group by Dr.BrandName, Dr.GenericName
											order by AVG(P.Refills) desc, Dr.BrandName, Dr.GenericName")
		render "index"
	 end

 	# View patients who have been prescribed a drug from a specific company
		 #USE VARIABLES
	def qD16
		cName = params[:cName]
	 	# @result = Table.connection.select_all("select Pa.CareCardNum, Pa.FirstName
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


private 

def get_user_attributes
	@userlicense = current_user.license_num
	@userCCNum = current_user.care_card_num
	@userPharmAddr = current_user.pharmacy_address
	Rails.logger.info ">>>>>>>>> #{@userlicense} <<<<<<<"
	Rails.logger.info ">>>>>>>>> #{@userCCNum} <<<<<<<"
	Rails.logger.info ">>>>>>>>> #{@userPharmAddr} <<<<<<<"
end


# def table_params
# 		params.require(:table).permit(:identity, :var1)
# end

end
