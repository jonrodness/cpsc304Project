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
		# TESTED - WORKS
		# modified this to return a more useful result -Alfred
		@result = Table.connection.select_all("select CONCAT(D.FirstName, ' ', D.LastName) as DoctorName, D.Type, P.Dosage, P.date_prescribed from Doctor D, Prescription P where D.LicenseNum=P.LicenseNum group by D.LastName")
		# @result = Table.connection.select_all("select Pr.PrescriptID, 
		# 									   from Prescription Pr, Doctor D 
		# 									   where Pr.LicenseNum=D.LicenseNum")
		render "index"
	end

	# Update prescription status
		# TESTED - WORKS
	 def qPh2
	 	prescription = params[:prescription]
		Table.connection.execute("update Prescription set ReadyForPickUp=1 
								  where PrescriptID ='#{prescription}' and ReadyForPickup=0")
		@result = Table.connection.select_all("SELECT * FROM Drug")
	 	render "index"
	 end

	 # View past prescriptions
		 # TESTED - WORKS
	 def qPh3
	 	ccNum = params[:ccNum]
		@result = Table.connection.select_all("select Pr.date_prescribed,I.GenericName,Pr.Refills,Pr.Dosage
												from Prescription Pr, Patient P, Includes I
												where Pr.CareCardNum = P.CareCardNum AND I.PrescriptID=Pr.PrescriptID AND Pr.CareCardNum = '#{ccNum}'
												Order By Pr.date_prescribed")
		render "index"
	 end

	 # Print out a list of prescriptions filled that day
	 	# CAN'T TEST WITHOUT PRESCRIPTIONS FOR THE CURRENT DAY
	 def qPh4
	 	@result = Table.connection.select_all("select I.GenericName, Pr.Dosage 
	 											from Prescription Pr, Patient P, Includes I 
	 											where Pr.PrescriptID=I.PrescriptID and 
	 											Pr.CareCardNum = P.CareCardNum and 
	 											Pr.date_prescribed = curdate()")
	 	render "index"
	 end

	 # Reduce the refill number of a patient’s prescription
		 # TESTED - WORKS
	 def qPh5
	 	prescription = params[:prescription]
		Table.connection.execute("update Prescription set Refills=Refills-1 
								  where PrescriptID = '#{prescription}' and Refills > 0")
		@result = Table.connection.select_all("SELECT Refills, PrescriptID, Dosage FROM Prescription WHERE PrescriptID=#{prescription}")
		render "index"
	 end

	 ############################# Patient Queries ################################

	 # Update personal information
		 # USE VARIABLES FOR firstname, lastname, age, weight, height, address, phonenumber, CareCardNum
		 # USE EXECUTE, NOT CONNECTION!
     # TESTED - WORKS
	 def qPa1
	 	pFName = params[:pFName]
	 	pLName = params[:pLName]
	 	pAge = params[:pAge]
	 	pWeight = params[:pWeight]
	 	pHeight = params[:pHeight]
	 	pAddress = params[:pAddress]
	 	pPhoneNum = params[:pPhoneNum]
	 	pCCNum = params[:pCCNum]
	 	Table.connection.execute("update Patient set FirstName = '#{pFName}', 
                                                    LastName = '#{pLName}', 
                                                    Age = #{pAge}, 
                                                    Weight = #{pWeight}, 
                                                    Height = #{pHeight}, 
                                                    Address = '#{pAddress}', 
                                                    PhoneNumber = '#{pPhoneNum}' 
                                where CareCardNum LIKE '#{@userCCNum}'")
    @result = Table.connection.select_all("SELECT * FROM Patient where CareCardNum LIKE '#{@userCCNum}'")
	 	render "index"
	 end

	 # Pharmacies that are currently open: Weekday
	 # TESTED - WORKS
	 def qPa2
	 	@result = Table.connection.select_all("select * from Pharmacy P where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing")
		render "index"
	 end

	 # Pharmacies that are currently open: Weekend
	 # TESTED - WORKS
	 def qPa3
	 	@result = Table.connection.select_all("select * from Pharmacy P where curtime() between P.WeekendHoursOpening and P.WeekendHoursClosing")
		render "index"
	 end

	 # Make an Appointment
		 # USE VARIABLES FOR start and end time, doctorid
		 # ADD VARIABLE FOR ccNum (from current_user)
		 # USE EXECUTE, NOT CONNECTION!
     # TESTED - WORKS
	 def qPa4
	 # 	date = params[:date]
	 # 	sTime = params[:sTime]
	 # 	eTime = params[:eTime]
	 # 	license = params[:license]
	 # 	# Table.connection.select_all("insert into TimeBlock values ('2874-06-07', '12:30:00', '15:30:00')")
	 # 	# Table.connection.select_all("insert into MakesAppointmentWith values (curdate(), curtime(), '1232131241', '2874-06-07', '12:30:00', '15:30:00', '1234567890')")
		# render "index"
		date = params[:date]
    sTime = params[:sTime]
    eTime = params[:eTime]
    license = params[:license]
        
        Table.connection.execute("insert into TimeBlock values ('#{date}',
        													    '#{sTime}',
        													    '#{eTime}')")

        # this line causing problems maybe
        Table.connection.execute("insert into MakesAppointmentWith values (curtime(),
        																   curdate(),
        																   '#{license}', 
        																   '#{date}', 
        																   '#{sTime}', 
        																   '#{eTime}', 
        																   '#{@userCCNum}')")
       
        @result = Table.connection.select_all("SELECT * FROM Drug")
        render "index"
	 end

	 # Cancel an Appointment
		 # USE VARIABLES FOR start and end time
		 # ADD VARIABLE FOR ccNum (from current_user)
		 # USE EXECUTE, NOT CONNECTION!
		 # TESTED - WORKS
	 def qPa5
	 	date = params[:date]
	 	sTime = params[:sTime]
	 	@result = Table.connection.select_all("SELECT * FROM Drug")
	 	Table.connection.execute("delete from MakesAppointmentWith where CareCardNum = '#{@userCCNum}' and TimeBlockDate = '#{date}' and StartTime = '#{sTime}'")
		render "index"
	 end

	# View all upcoming appointments
		# ADD VARIABLE for ccNum
		# TESTED - WORKS
	 def qPa6a
	 	@result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '#{@userCCNum}'")
		render "index"
	 end

	# View upcoming appointments by date
		# USE VARIABLE FOR date
	 	# ADD VARIABLE for ccNum
	 	# TESTED - WORKS
	 def qPa6b
	 	date = params[:date]
	 	@result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '#{@userCCNum}' and MakeApptW.TimeBlockDate = '#{date}'")
		render "index"
	 end
	
	# View upcoming appointments by time	
		# USE VARIABLES FOR start and end time
		# ADD VARIABLE for ccNum
		# TESTED - WORKS
	 def qPa6c
	 	sTime = params[:sTime]
	 	eTime = params[:eTime]
	 	@result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '#{@userCCNum}' and MakeApptW.StartTime >=  '#{sTime}'  and MakeApptW.EndTime <=  '#{eTime}'")
		render "index"
	 end

	 # Check Drug Interactions
	 	# USE VARIABLE FOR drug
	 	# TESTED - WORKS
	 def qPa7
	 	drug = params[:drug]
	 	@result = Table.connection.select_all("select iGenericName from InteractsWith where LCASE(dGenericName) like '%#{drug}%'")
		render "index"
	 end

	 # Check Interactions for this prescriptionID
	 	# USE VARIABLES FOR prescription
	 	# do we need variable for patientID?
	 	# TESTED - WORKS
	 def qPa8
	 	prescription = params[:prescription]
	 	@result = Table.connection.select_all("select distinct IW.iBrandName as 'Brand name', IW.iGenericName as 'Generic name' from Prescription P, InteractsWith IW, Includes I, Drug D1, Drug D2 where P.PrescriptID LIKE '#{prescription}' and P.PrescriptID = I.PrescriptID and I.BrandName = D1.BrandName and I.GenericName = D1.GenericName and IW.dBrandName = D1.BrandName and IW.dGenericName = D1.GenericName and IW.iBrandName != D1.BrandName and IW.iGenericName != D1.GenericName")
		render "index"
	 end

	 # View Prescription Status
	 # TESTED - WORKS
	 def qPa9
	 	@result = Table.connection.select_all("select * from Prescription where ReadyForPickup=1")
		render "index"
	 end

	 # Generate Report: Current Prescription
	 	# ADD VARIABLE FOR CCNum
	 	# TESTED - WORKS
	 def qPa10
	 	@result = Table.connection.select_all("select distinct Pr.PrescriptID as 'Prescription ID', (Pr.date_prescribed) as 'Date prescribed', CONCAT(D.FirstName, ' ', D.LastName) as 'Prescribed by', CONCAT (Dr.BrandName, ' ', Dr.GenericName) as Drug, Pr.dosage as 'Drug dosage',  Pr.refills as 'Refills' from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr where P.CareCardNum LIKE '#{@userCCNum}' and P.CareCardNum = Pr.CareCardNum and Pr.LicenseNum = D.LicenseNum and I.PrescriptID = Pr.PrescriptID and I.BrandName = Dr.BrandName and I.GenericName = Dr.GenericName and Pr.refills > 0 order by Pr.date_prescribed desc")
		render "index"
	 end

	 # Generate Report: Previous Prescription
	 	# ADD VARIABLE FOR CCNum
	 	# TESTED - WORKS
	 def qPa11
	 	@result = Table.connection.select_all("select distinct Pr.PrescriptID as 'Prescription ID', (Pr.date_prescribed) as 'Date prescribed', CONCAT(D.FirstName, ' ', D.LastName) as 'Prescribed by', CONCAT (Dr.BrandName, ' ', Dr.GenericName) as Drug, Pr.dosage as 'Drug dosage',  Pr.refills as 'Refills' from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr where P.CareCardNum LIKE '#{@userCCNum}' and P.CareCardNum = Pr.CareCardNum and Pr.LicenseNum = D.LicenseNum and I.PrescriptID = Pr.PrescriptID and I.BrandName = Dr.BrandName and I.GenericName = Dr.GenericName and Pr.refills = 0 order by Pr.date_prescribed desc")
		render "index"
	 end

 	############################# Doctor Queries ################################

 	# Update personal information
	 	# ADD VARIABLES
	 	# TESTED - WORKS
	 	# USE EXECUTE, NOT CONNECTION!
	 def qD1
	 	dFName = params[:dFName]
	 	dLName = params[:dLName]
	 	dAddress = params[:dAddress]
	 	dPhoneNum = params[:dPhoneNum]
	 	dSpecialty =  params[:dSpecialty]
	 	dLicenseNum = current_user.license_num
	 	Table.connection.execute("update Doctor set FirstName = '#{dFName}', LastName = '#{dLName}',
										Address = '#{dAddress}', PhoneNumber = '#{dPhoneNum}', Type = '#{dSpecialty}'
									     where LicenseNum = '#{dLicenseNum}'")
	 	@result = Table.connection.select_all("select * from Doctor where LicenseNum = '#{dLicenseNum}'")
		render "index"
	 end

	 # Prescribe a Drug
	 	# USE VARIABLES
	 	# TESTED - WORKS
	 	# ARE THESE THE CORRECT VARIABLES?
	 	# USE EXECUTE, NOT CONNECTION!
	 def qD2
	 	prescription  = params[:prescription]
	 	refills = params[:refills]
	 	dosage = params[:dosage]
	 	ccNum = params[:ccNum]
	 	dLicenseNum = current_user.license_num
	 	Table.connection.execute("insert into Prescription values ('#{dLicenseNum}', '#{prescription}', #{refills}, '#{dosage}', '#{ccNum}', 0, NOW())")
	 	@result = Table.connection.select_all("SELECT * FROM Prescription WHERE Prescription.PrescriptID = #{prescription}")
		render "index"
	 end

 	# Pharmacies that are currently open: Weekday
 		# TESTED - WORKS
	 def qD3
	 	@table = Table.new
	 	@result = Table.connection.select_all("select * from Pharmacy P where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing")
		render "index"
	 end
 	
 	# Pharmacies that are currently open: Weekend
 		# TESTED - WORKS
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
														D.LicenseNum  = '#{@userlicense}'
												order by MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate")
		render "index"
	 end

	 # View Appointments on a certain date
	 def qD6
	 	date = params[:date]
	 	@result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
														CONCAT(P.FirstName, ' ', P.LastName) as 'Patient',  
														CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on '
												from MakesAppointmentWith MakeApptW, Doctor D, Patient P
												where MakeApptW.LicenseNum = D.LicenseNum and
														MakeApptW.CareCardNum = P.CareCardNum and
														D.LicenseNum  = '#{@userlicense}' and
														MakeApptW.TimeBlockDate = '#{date}'")
		render "index"
	 end

	 # View Appointments during a certain time
	 def qD7
	 	sTime = params[:sTime]
	 	eTime = params[:eTime]
	 	@result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
														CONCAT(P.FirstName, ' ', P.LastName) as 'Patient',  
														CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on '
												from MakesAppointmentWith MakeApptW, Doctor D, Patient P
												where MakeApptW.LicenseNum = D.LicenseNum and
														MakeApptW.CareCardNum = P.CareCardNum and
														D.LicenseNum  = '#{@userlicense}' and
														MakeApptW.StartTime >=  '#{sTime}'  and
														MakeApptW.StartTime <=  '#{eTime}'")
		render "index"
	 end

	 # View patient information
	 	# TESTED - WORKS
	 	# DO WE WANT TO LIMIT THIS TO ONLY THE PATIENTS THIS DOCTOR SEES?
	 def qD8
	 	ccNum = params[:ccNum]
	 	@result = Table.connection.select_all("select *
												from Patient
												where CareCardNum = '#{ccNum}'")
		render "index"
	 end

	 # View a list of previous prescriptions for a certain patient
	 	 # TESTED - WORKS
	 def qD9
	 	ccNum = params[:ccNum]
	 	@result = Table.connection.select_all("select Pr.PrescriptID 
										 		from Prescription Pr, Doctor D, Patient P 
										 		where Pr.LicenseNum = D.LicenseNum and
										 		P.CareCardNum = '#{ccNum}'")
		render "index"
	 end

	 # View a list of previous drugs prescribed to a certain patient
	 	# TESTED - WORKS
	 	# DO WE WANT TO LIMIT THIS TO ONLY THE PATIENTS THIS DOCTOR SEES?
	 def qD10
	 	ccNum = params[:ccNum]
	 	@result = Table.connection.select_all("select I.GenericName
												from Prescription Pr, Patient P, Includes I
												where P.CareCardNum = '#{ccNum}' AND Pr.CareCardNum=P.CareCardNum AND I.PrescriptID=Pr.PrescriptID;")
		render "index"
	 end

	 # Check if a certain drug was taken in the past by a certain patient
	 	# TESTED - WORKS, BUT SEARCHING BY GENERIC NAME YIELDS MULTIPLE ROWS FOR EACH RECORD
	 def qD11
	 	ccNum = params[:ccNum]
	 	brandName = params[:brandName]
	 	genericName = params[:genericName]
	 	@result = Table.connection.select_all("select Pr.LicenseNum as 'Prescribed by', Pr.PrescriptID as 'Prescription ID', Pr.Dosage, Pr.date_prescribed
												from Patient P, Prescription Pr, Includes I
												where P.CareCardNum = Pr.CareCardNum and
													P.CareCardNum = '#{ccNum}' and
													Pr.PrescriptID = I.PrescriptID and
													I.BrandName LIKE '#{brandName}' or
													I.GenericName LIKE '#{genericName}'")
		render "index"
	 end

	 # View possible drug interactions
	 	# TESTED - WORKS, BUT SHOULDN'T HAVE TO ADD BOTH GENERIC AND BRAND NAMES
	 def qD12
	 	iBrandName = params[:iBrandName]
	 	iGenericName = params[:iGenericName]
	 	@result = Table.connection.select_all("select D.GenericName, D.BrandName
												from InteractsWith I, Drug D
												where (I.dBrandName = '#{iBrandName}' and
														I.dGenericName = '#{iGenericName}' and
														I.iGenericName = D.GenericName and
														I.iBrandName = D.BrandName) or
														(I.iBrandName = '#{iBrandName}' and
														I.iGenericName = '#{iGenericName}' and
														I.dBrandName = D.BrandName and
														I.dGenericName = D.GenericName)")
		render "index"
	 end

	 # View patient's past appointments
	 	# CANNOT TEST BECAUSE ALL POPULATIONS IN SCRIPT FOR MAKESAPPOINTMENT ARE IN FUTURE
	 def qD13
	 	ccNum = params[:ccNum]
	 	@result = Table.connection.select_all("select *
												from MakesAppointmentWith M, Doctor D, Patient P
												where D.LicenseNum = M.LicenseNum and
													M.CareCardNum = P.CareCardNum and
													P.CareCardNum = '#{ccNum}' and
													D.LicenseNum = '#{@userlicense}' and
													TimeBlockDate < curdate()")
		render "index"
	 end

	 # Generate a report about which prescriptions a doctor has previously prescribed...
	 	# TESTED - WORKS WITH STATIC LICENSE NUMBER
	 def qD14
	 	@result = Table.connection.select_all("select Pr.PrescriptID, CONCAT(P.FirstName, ' ', P.LastName) as PatientName, CONCAT (Dr.BrandName, ' ', Dr.GenericName) as Drug, CONCAT(Pm.Address, ', ', Pm.Name) as PharmacyDescription 
											from Prescription Pr, Doctor D, Patient P, Pharmacy Pm, OrderedFrom O, Includes I, Drug Dr
											where 	Pr.LicenseNum = D.LicenseNum and
													Pr.CareCardNum = P.CareCardNum and 
													O.PrescriptID = Pr.PrescriptID and 
													O.PharmacyAddress = Pm.Address and 
													I.PrescriptID = Pr.PrescriptID and
													I.BrandName = Dr.BrandName and
													I.GenericName = Dr.GenericName and
													D.LicenseNum LIKE '#{@userlicense}'")
		render "index"
	 end

	 # Show the average number of refills for a certain drug
	 		 # TESTED - WORKS
	 		 # NOT FOR SPECIFIC DRUG?
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
		 # TESTED - WORKS
	def qD16
		cName = params[:cName]
	 	@result = Table.connection.select_all("select Pa.CareCardNum, Pa.FirstName
											from Patient Pa
											Where NOT EXISTS
											     (Select *
											      from Drug D
											      Where D.CompanyName LIKE '#{cName}'
											      AND NOT EXISTS
											      (Select * 
											            From Prescription P, Includes I
											            WHERE P.PrescriptID = I.prescriptID and 
											            		I.BrandName = D.BrandName and
											            		P.CareCardNum = Pa.CareCardNum))")
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
