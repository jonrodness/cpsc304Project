class TablesController < ApplicationController
	before_action :get_user_attributes

	def index
		#@table = Table.new
		#@table.save
		if current_user.user_type == "Patient" && !@userCCNum.empty? 
			@result = Table.connection.select_all("SELECT CareCardNum as 'Care Card Number', FirstName as 'First Name', LastName as 'Last Name', Age, Weight, Height, Address, PhoneNumber as 'Phone Number' FROM Patient WHERE Patient.CareCardNum=#{current_user.care_card_num}")
			@title = "Your Personal Statistics"
		elsif current_user.user_type == "Doctor" && !@userlicense.empty? 
			@result = Table.connection.select_all("select LicenseNum as 'License Number', CONCAT(FirstName, ' ', LastName) as 'Doctor Name', Address, PhoneNumber as 'Phone Number', Type from Doctor where Doctor.LicenseNum=#{current_user.license_num}")
			@title = "Your Information"
		elsif current_user.user_type == "Pharmacist" && !@userPharmAddr.empty? 
			@result = Table.connection.select_all("select Address, Name, PhoneNumber as 'Phone Number', 
				TIME_FORMAT(WeekDayHoursOpening, '%h:%i%p') as 'Weekday Open', TIME_FORMAT(WeekDayHoursClosing, '%h:%i%p') as 'Weekday Close',
				TIME_FORMAT(WeekendHoursOpening, '%h:%i%p')  as 'Weekend Open', TIME_FORMAT(WeekendHoursClosing, '%h:%i%p') as 'Weekend Close'
				 from Pharmacy where Address like '#{current_user.pharmacy_address}'")
			@title = "Your Pharmacy Information"
		else
			@title = "List of drugs"
			@result = Table.connection.select_all("select * from Drug")
	end
				

	end

	def update
	end

############################# Pharmacist Queries ################################

	# View prescriptions prescribed by doctor
	def qPh1
		@result = Table.connection.select_all("select CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor Name', D.Type as 'Doctor Type', I.BrandName as 'Brand Name',  P.Dosage, P.date_prescribed as 'Date Prescribed' from Doctor D, Prescription P, Includes I  where D.LicenseNum=P.LicenseNum and I.PrescriptID=P.PrescriptID group by D.LastName")
		@title = "Prescriptions, sorted by doctors' last names"
		render "index"
	end

	# Update prescription status
	 def qPh2
	 	prescription = params[:prescription]

	 	# check that prescription number is a non-negative number
	 	assert {prescription.to_f >= 0}
		Table.connection.execute("update Prescription set ReadyForPickUp=1 
								  where PrescriptID ='#{prescription}' and ReadyForPickup=0")
		@result = Table.connection.select_all("select PrescriptID as 'Prescription ID',Refills, Dosage, CareCardNum as 'Care Card Number', ReadyForPickUp as 'Pickup Status', date_prescribed as 'Date Prescribed' from Prescription
								  where PrescriptID ='#{prescription}'")
		@title = "Prescription# #{prescription} is now ready for pickup!"
	 	render "index"
	 end

	 # View past prescriptions
	 def qPh3
	 	ccNum = params[:ccNum]
	 	# check that care card number is a non-negative number
	 	assert {ccNum.to_f >= 0}
		@result = Table.connection.select_all("select Pr.date_prescribed as 'Date Prescribed',I.GenericName as 'Generic Name',Pr.Refills,Pr.Dosage
												from Prescription Pr, Patient P, Includes I
												where Pr.CareCardNum = P.CareCardNum AND I.PrescriptID=Pr.PrescriptID AND Pr.CareCardNum = '#{ccNum}'
												Order By Pr.date_prescribed")
		@title = "Past prescriptions for patient# #{ccNum}"
		render "index"
	 end

	 # Gets a list of prescriptions filled that day
	 def qPh4
	 	@result = Table.connection.select_all("select Pr.PrescriptID as 'Prescription ID', I.GenericName as 'Generic Name', Pr.Dosage 
	 											from Prescription Pr, Patient P, Includes I 
	 											where Pr.PrescriptID=I.PrescriptID and 
	 											Pr.CareCardNum = P.CareCardNum and 
	 											Pr.date_prescribed = curdate()")
	 	@title = "Prescriptions filled today"
	 	render "index"
	 end

	 # Reduce the refill number of a patient’s prescription
	 def qPh5
	 	prescription = params[:prescription]

	 	# check that prescription number is a non-negative number
	 	assert {prescription.to_f >= 0}
		Table.connection.execute("update Prescription set Refills=Refills-1 
								  where PrescriptID = '#{prescription}' and Refills > 0")
		@result = Table.connection.select_all("SELECT PrescriptID as 'Prescription ID', Refills, Dosage FROM Prescription WHERE PrescriptID=#{prescription}")
		@title = "Prescription# #{prescription} has had refills reduced by 1"
		render "index"
	 end

	 # Show all drugs in the database
	 def qPh6
	 	@result = Table.connection.select_all("select BrandName as 'Brand Name', GenericName as 'Generic Name', CompanyName as 'Company Name', Price 
                                            from Drug")
	 	@title = "List of drugs"
	 	render "index"
	 end

	 # Delete a drug from the database
	 def qPh7
	 	brandName = params[:brandName]
	 	genericName = params[:genericName]
	 	# check that brandName field is not empty
	 	assert {!brandName.empty?}
	 	# check that genericName field is not empty
	 	assert {!genericName.empty?}
	 	Table.connection.execute("delete 
									from Drug
									where BrandName = '#{brandName}' and
										GenericName = '#{genericName}'")
	 	@result = Table.connection.select_all("select * from Drug")
	 	render "index"
 	 end

	 ############################# Patient Queries ################################

	 # Update patient address
	 def qPa1a
	 	pAddress = params[:pAddress]
	 	# check that address field is not empty
	 	assert {!pAddress.empty?}
	 	Table.connection.execute("update Patient set Address = '#{pAddress}'
                                where CareCardNum LIKE '#{@userCCNum}'")
    @result = Table.connection.select_all("SELECT CareCardNum as 'Care Card Number', FirstName as 'First Name', LastName as 'Last Name', Age, Weight, Height, Address, PhoneNumber as 'Phone Number' FROM Patient where CareCardNum LIKE '#{@userCCNum}'")
	 	@title = "Update successful! Your address in the database is now #{pAddress}"
	 	render "index"
	 end

	 # Update patient phone number
	 def qPa1b
	 	pPhoneNum = params[:pPhoneNum]

	 	# check that phone number is 10 digits
	 	assert {pPhoneNum.length == 10}
	 	Table.connection.execute("update Patient set PhoneNumber = '#{pPhoneNum}' 
                                where CareCardNum LIKE '#{@userCCNum}'")

    	@result = Table.connection.select_all("SELECT CareCardNum as 'Care Card Number', FirstName as 'First Name', LastName as 'Last Name', Age, Weight, Height, Address, PhoneNumber as 'Phone Number' FROM Patient where CareCardNum LIKE '#{@userCCNum}'")
    	@title = "Update successful! Your phone number in the database is now #{pPhoneNum}"
    	# @result = Table.connection.select_all("SELECT * FROM Patient where CareCardNum LIKE '#{@userCCNum}'")
	 	render "index"
	 end

	 # Pharmacies that are currently open: Weekday
	 def qPa2
	 	@result = Table.connection.select_all("select Address, Name, PhoneNumber, TIME_FORMAT(WeekDayHoursOpening, '%h:%i%p')  as 'Weekday Opening', TIME_FORMAT(WeekDayHoursClosing, '%h:%i%p')  as 'Weekday Closing', TIME_FORMAT(WeekendHoursOpening, '%h:%i%p') as 'Weekend Closing', TIME_FORMAT(WeekendHoursClosing, '%h:%i%p') as 'Weekend Closing' from Pharmacy P where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing")
		@title = "Pharmacies open right now"
		render "index"
	 end

	 # Pharmacies that are currently open: Weekend
	 def qPa3
	 	@result = Table.connection.select_all("select Address, Name, PhoneNumber, TIME_FORMAT(WeekDayHoursOpening, '%h:%i%p')  as 'Weekday Opening', TIME_FORMAT(WeekDayHoursClosing, '%h:%i%p')  as 'Weekday Closing', TIME_FORMAT(WeekendHoursOpening, '%h:%i%p') as 'Weekend Closing', TIME_FORMAT(WeekendHoursClosing, '%h:%i%p') as 'Weekend Closing' from Pharmacy P where curtime() between P.WeekendHoursOpening and P.WeekendHoursClosing")
		@title = "Pharmacies open right now"
		render "index"
	 end

	 # Make an Appointment
	 def qPa4
		date = params[:date]
	    sTime = params[:sTime]
	    startTime = sTime["test(4i)"] + ":" + sTime["test(5i)"]
	    eTime = params[:eTime]
	    endTime = eTime["test(4i)"] + ":" + eTime["test(5i)"]
	    license = params[:license]
	    # check that license field is not empty
	 	assert {!license.empty?}	    
	    Table.connection.execute("insert into TimeBlock values ('#{date}',
	        													    '#{startTime}',
	        													    '#{endTime}')")
		Table.connection.execute("insert into MakesAppointmentWith values (curtime(),
	        																   curdate(),
        																   '#{license}', 
        																   '#{date}', 
        																   '#{startTime}', 
        																   '#{endTime}', 
        																   '#{@userCCNum}')")
       	@title = "Appointment made! Details below about your upcoming appointments..."
      	@result = Table.connection.select_all("select TIME_FORMAT(MakeApptW.StartTime, '%h:%i%p') as 'Start Time', TIME_FORMAT(MakeApptW.EndTime, '%h:%i%p') as 'End Time', MakeApptW.TimeBlockDate as 'Date', CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '#{@userCCNum}'")

        render "index"
	 end

	 # Cancel an Appointment
	 def qPa5
	 	date = params[:date]
	 	sTime = params[:sTime]
	 	startTime = sTime["test(4i)"] + ":" + sTime["test(5i)"]
	 	Table.connection.execute("delete from MakesAppointmentWith where CareCardNum = '#{@userCCNum}' and TimeBlockDate = '#{date}' and StartTime = '#{startTime}'")
	 	@result = Table.connection.select_all("select TIME_FORMAT(MakeApptW.StartTime, '%h:%i%p') as 'Start Time', TIME_FORMAT(MakeApptW.EndTime, '%h:%i%p') as 'End Time', MakeApptW.TimeBlockDate as 'Date', CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '#{@userCCNum}'")
		@title = "Appointment cancelled! Showing upcoming appointments..."

		render "index"
	 end

	# View all upcoming appointments
	 def qPa6a
	 	@result = Table.connection.select_all("select TIME_FORMAT(MakeApptW.StartTime, '%h:%i%p') as 'Start Time', TIME_FORMAT(MakeApptW.EndTime, '%h:%i%p') as 'End Time', MakeApptW.TimeBlockDate as 'Date', CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '#{@userCCNum}'")
		@title = "Upcoming appointments"
		render "index"
	 end

	# View upcoming appointments by date
	 def qPa6b
	 	date = params[:date]
	 	@result = Table.connection.select_all("select TIME_FORMAT(MakeApptW.StartTime, '%h:%i%p') as 'Start Time', TIME_FORMAT(MakeApptW.EndTime, '%h:%i%p') as 'End Time', MakeApptW.TimeBlockDate as 'Date', CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' from MakesAppointmentWith MakeApptW, Doctor D, Patient P where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '#{@userCCNum}' and MakeApptW.TimeBlockDate = '#{date}'")
		@title = "Your appointments on #{date}"
		render "index"
	 end
	
	# View upcoming appointments by time	
	 def qPa6c
	 	sTime = params[:sTime]
	 	startTime = sTime["test(4i)"] + ":" + sTime["test(5i)"]
	 	eTime = params[:eTime]
	 	endTime = eTime["test(4i)"] + ":" + eTime["test(5i)"]
	 	@result = Table.connection.select_all("select TIME_FORMAT(MakeApptW.StartTime, '%h:%i%p') as 'Start Time', TIME_FORMAT(MakeApptW.EndTime, '%h:%i%p') as 'End Time', 
	 		MakeApptW.TimeBlockDate as 'Date', CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', 
	 		CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' 
	 		from MakesAppointmentWith MakeApptW, Doctor D, Patient P 
	 		where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and 
	 		P.CareCardNum = '#{@userCCNum}' and MakeApptW.StartTime >=  '#{startTime}'  and MakeApptW.EndTime <=  '#{endTime}'")
		@title = "Your appointments between #{startTime} and #{endTime}"

		render "index"
	 end

	 # Check Drug Interactions
	 def qPa7
	 	drug = params[:drug]
    @namesArray = Table.connection.select_all("select BrandName from Drug")
    Rails.logger.info ">>>>>>>>>>>>>>#{@namesArray.as_json}<<<<<<<<<<<<<<<<" ## TODO: make this a dropdown box
    @namesArrayJSON = @namesArray.as_json
	 	# check that drug field is not empty
	 	assert {!drug.empty?}
	 	@result = Table.connection.select_all("select iBrandName as 'Brand Name', iGenericName as 'Generic Name' from InteractsWith where LCASE(dGenericName) like '%#{drug}%'")
	 	@title = "Drugs that interact with #{drug}"
		render "index"
	 end

	 # Check Interactions for this prescriptionID
	 def qPa8
	 	prescription = params[:prescription]
	 	# check that prescription field is not empty
	 	assert {!prescription.empty?}
	 	# check that prescription is a non-negative number
	 	assert {prescription.to_f >= 0}
	 	@result = Table.connection.select_all("select distinct IW.iBrandName as 'Brand name', IW.iGenericName as 'Generic name' from Prescription P, InteractsWith IW, Includes I, Drug D1, Drug D2 where P.PrescriptID LIKE '#{prescription}' and P.PrescriptID = I.PrescriptID and I.BrandName = D1.BrandName and I.GenericName = D1.GenericName and IW.dBrandName = D1.BrandName and IW.dGenericName = D1.GenericName and IW.iBrandName != D1.BrandName and IW.iGenericName != D1.GenericName")
		@title = "Drugs that interact with drugs in prescription# #{prescription}"
		render "index"
	 end

	 # View Prescription Status
	 def qPa9
	 	@result = Table.connection.select_all("select 
	 	LicenseNum as 'Doctor Number', PrescriptID as 'Prescription ID', Refills, Dosage, 
	 	CareCardNum as 'Care Card Number', ReadyForPickUp as 'Pickup Status',  	
	 	date_prescribed as 'Date Prescribed'
	 	 from Prescription where ReadyForPickup=1")
	 	@title = "Prescription status"
		render "index"
	 end

	 # Generate Report: Current Prescription
	 def qPa10
	 	@result = Table.connection.select_all("select distinct Pr.PrescriptID as 'Prescription ID', (Pr.date_prescribed) as 'Date prescribed', CONCAT(D.FirstName, ' ', D.LastName) as 'Prescribed by', CONCAT (Dr.BrandName, '/', Dr.GenericName) as Drug, Pr.dosage as 'Drug dosage',  Pr.refills as 'Refills' from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr where P.CareCardNum LIKE '#{@userCCNum}' and P.CareCardNum = Pr.CareCardNum and Pr.LicenseNum = D.LicenseNum and I.PrescriptID = Pr.PrescriptID and I.BrandName = Dr.BrandName and I.GenericName = Dr.GenericName and Pr.refills > 0 order by Pr.date_prescribed desc")
		@title = "Current prescriptions:"
		render "index"
	 end

	 # Generate Report: Previous Prescription
	 def qPa11
	 	@result = Table.connection.select_all("select distinct Pr.PrescriptID as 'Prescription ID', (Pr.date_prescribed) as 'Date prescribed', CONCAT(D.FirstName, ' ', D.LastName) as 'Prescribed by', CONCAT (Dr.BrandName, '/', Dr.GenericName) as Drug, Pr.dosage as 'Drug dosage',  Pr.refills as 'Refills' from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr where P.CareCardNum LIKE '#{@userCCNum}' and P.CareCardNum = Pr.CareCardNum and Pr.LicenseNum = D.LicenseNum and I.PrescriptID = Pr.PrescriptID and I.BrandName = Dr.BrandName and I.GenericName = Dr.GenericName and Pr.refills = 0 order by Pr.date_prescribed desc")
		@title = "Previous prescriptions:"
		render "index"
	 end

                                                                 

 	############################# Doctor Queries ################################

 	# Update doctor address
	 def qD1a
	 	dAddress = params[:dAddress]
	 	Table.connection.execute("update Doctor set Address = '#{dAddress}'")
	 	@result = Table.connection.select_all("select LicenseNum as 'License Number', CONCAT(FirstName, ' ', LastName) as 'Doctor Name', Address, PhoneNumber as 'Phone Number', Type from Doctor where Doctor.LicenseNum=#{current_user.license_num}")
		@title = "Your address was updated to: #{dAddress}"
		render "index"
	 end

	 # Update doctor phone number
	 def qD1b
	 	dPhoneNum = params[:dPhoneNum]
	 	# check that phone number is 10 digits
	 	assert {dPhoneNum.length == 10}
	 	Table.connection.execute("update Doctor set PhoneNumber = '#{dPhoneNum}'")
	 	@result = Table.connection.select_all("select LicenseNum as 'License Number', CONCAT(FirstName, ' ', LastName) as 'Doctor Name', Address, PhoneNumber as 'Phone Number', Type from Doctor where Doctor.LicenseNum=#{current_user.license_num}")
		@title = "Your Phone Number was updated to: #{dPhoneNum}"
		render "index"
	 end

	 # Update patient height
	 def qD1c
	 	pHeight = params[:pHeight]
	 	ccNum = params[:ccNum]

	 	# check that fields are filled
	 	assert {!pHeight.empty?}
	 	assert {!ccNum.empty?}

	 	# check that height is non-negative number
	 	assert {pHeight.to_f >= 0}

	 	# check that care card number is a non-negative number
	 	assert {ccNum.to_f >= 0}

	 	Table.connection.execute("update Patient set Height = '#{pHeight}'
                                where CareCardNum LIKE '#{ccNum}'")
    	@result = Table.connection.select_all("select CareCardNum as 'Care Card Number', FirstName as 'First Name', LastName as 'Last Name', Age, Weight, Height, Address, PhoneNumber as 'Phone Number' 
												from Patient
												where CareCardNum = '#{ccNum}'")
    	@title = "Patient ##{ccNum}'s height was updated to #{pHeight}"
	 	render "index"
	 end

	 # Update patient weight
	 def qD1d
	 	pWeight = params[:pWeight]
	 	ccNum = params[:ccNum]

	 	# check that fields are filled
	 	assert {!pWeight.empty?}
	 	assert {!ccNum.empty?}

	 	# check that weight is non-negative number
	 	assert {pWeight.to_f >= 0}

	 	# check that care card number is a non-negative number
	 	assert {ccNum.to_f >= 0}

	 	Table.connection.execute("update Patient set Weight = '#{pWeight}'
                                where CareCardNum LIKE '#{ccNum}'")
   	@result = Table.connection.select_all("select CareCardNum as 'Care Card Number', FirstName as 'First Name', LastName as 'Last Name', Age, Weight, Height, Address, PhoneNumber as 'Phone Number' 
										from Patient
										where CareCardNum = '#{ccNum}'")
   	@title = "Patient ##{ccNum}'s weight was updated to #{pWeight}"
	 	render "index"
	 end

	 # Prescribe a Drug
	 def qD2
	 	prescription  = params[:prescription]
	 	refills = params[:refills]
	 	dosage = params[:dosage]
	 	ccNum = params[:ccNum]
	 	bName = params[:bName]
	 	gName = params[:gName]

	 	# check that fields are filled
	 	assert {!prescription.nil?}
	 	assert {!refills.nil?}
	 	assert {!dosage.nil?}
	 	assert {!ccNum.nil?}
	 	assert {!bName.nil?}
	 	assert {!gName.nil?}

	 	# check that prescription, refills, dosage, and ccNum are non-negative numbers
	 	assert {prescription.to_f >= 0}
	 	assert {refills.to_f >= 0}
	 	assert {ccNum.to_f >= 0}

	 	dLicenseNum = current_user.license_num
	 	Table.connection.execute("insert into Prescription values ('#{dLicenseNum}', '#{prescription}', #{refills}, '#{dosage}', '#{ccNum}', 0, NOW())")
	 	Table.connection.execute("insert into Includes values ('#{prescription}', '#{bName}', '#{gName}')")
	 	@result = Table.connection.select_all("SELECT LicenseNum as 'License Number', PrescriptID as 'Prescription ID', Refills, Dosage, CareCardNum as 'Care Card Number', ReadyForPickUp 'Pickup Status', date_prescribed as 'Date Prescribed'
	 	 FROM Prescription WHERE Prescription.PrescriptID = #{prescription}")
	 	@title = "Prescription created! Details below"

		render "index"
	 end

 	# Pharmacies that are currently open: Weekday
	 def qD3
	 	@table = Table.new
	 	@result = Table.connection.select_all("select Address, Name, PhoneNumber, TIME_FORMAT(WeekDayHoursOpening, '%h:%i%p')  as 'Weekday Opening', TIME_FORMAT(WeekDayHoursClosing, '%h:%i%p')  as 'Weekday Closing', TIME_FORMAT(WeekendHoursOpening, '%h:%i%p') as 'Weekend Closing', TIME_FORMAT(WeekendHoursClosing, '%h:%i%p') as 'Weekend Closing' from Pharmacy P where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing")
		@title = "Pharmacies open right now"
		render "index"
	 end
 	
 	# Pharmacies that are currently open: Weekend
	 def qD4
	 	@table = Table.new
	 	@result = Table.connection.select_all("select Address, Name, PhoneNumber, TIME_FORMAT(WeekDayHoursOpening, '%h:%i%p')  as 'Weekday Opening', TIME_FORMAT(WeekDayHoursClosing, '%h:%i%p')  as 'Weekday Closing', TIME_FORMAT(WeekendHoursOpening, '%h:%i%p') as 'Weekend Closing', TIME_FORMAT(WeekendHoursClosing, '%h:%i%p') as 'Weekend Closing' from Pharmacy P where curtime() between P.WeekendHoursOpening and P.WeekendHoursClosing")
		@title = "Pharmacies open right now"
		render "index"
	 end

	# View Appointments for picked date and time
	 def qD5
	 	@result = Table.connection.select_all("select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
														CONCAT(P.FirstName, ' ', P.LastName) as 'Patient',  
														CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on '
												from MakesAppointmentWith MakeApptW, Doctor D, Patient P
												where MakeApptW.LicenseNum = D.LicenseNum and
														MakeApptW.CareCardNum = P.CareCardNum and
														D.LicenseNum  = '#{@userlicense}'
												order by MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate")
	 	@title = "Appointments ordered chronologically"
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
	 	@title = "Appointments on #{date}"
		render "index"
	 end


	 # View Appointments during a certain time
	 def qD7
	 	sTime = params[:sTime]
	 	startTime = sTime["test(4i)"] + ":" + sTime["test(5i)"]
	 	eTime = params[:eTime]
	 	endTime = eTime["test(4i)"] + ":" + eTime["test(5i)"]

	 	@result = Table.connection.select_all("select MakeApptW.StartTime as 'Start Time', MakeApptW.EndTime as 'End Time', MakeApptW.TimeBlockDate as 'Date',
														CONCAT(P.FirstName, ' ', P.LastName) as 'Patient',  
														CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on '
												from MakesAppointmentWith MakeApptW, Doctor D, Patient P
												where MakeApptW.LicenseNum = D.LicenseNum and
														MakeApptW.CareCardNum = P.CareCardNum and
														D.LicenseNum  = '#{@userlicense}' and
														MakeApptW.StartTime >=  '#{startTime}'  and
														MakeApptW.EndTime <=  '#{endTime}'")
	 	@title = "Your appointments between #{startTime} and #{endTime}"
		render "index"
	 end

	 # View patient information
	 def qD8
	 	ccNum = params[:ccNum]

	 	# check that care card number is a non-negative number
	 	assert {ccNum.to_f >= 0}
	 	@result = Table.connection.select_all("select CareCardNum as 'Care Card Number', FirstName as 'First Name', LastName as 'Last Name', 
	 		Age, Weight, Height, Address, PhoneNumber as 'Phone Number'
												from Patient
												where CareCardNum = '#{ccNum}'")
	 	@title = "Patient information"
		render "index"
	 end

	 # View a list of previous prescriptions for a certain patient
	 def qD9
	 	ccNum = params[:ccNum]
	 	# check that care card number is a non-negative number
	 	assert {ccNum.to_f >= 0}
	 	@result = Table.connection.select_all("select CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor Name', 
	 		D.Type as 'Doctor Type', I.BrandName as 'Brand Name',  
	 		P.Dosage, P.date_prescribed as 'Date Prescribed' 
	 		from Doctor D, Prescription P, Includes I  
	 		where #{@userlicense}=P.LicenseNum and I.PrescriptID=P.PrescriptID group by D.LastName")

	 	# @result = Table.connection.select_all("select Pr.PrescriptID 
			# 							 		from Prescription Pr, Doctor D, Patient P 
			# 							 		where Pr.LicenseNum = D.LicenseNum and
			# 							 		P.CareCardNum = '#{ccNum}'")
		@title = "Prescription Information"
		render "index"
	 end

	 # View a list of previous drugs prescribed to a certain patient
	 def qD10
	 	ccNum = params[:ccNum]
	 	# check that care card number is a non-negative number
	 	assert {ccNum.to_f >= 0}
	 	@result = Table.connection.select_all("select I.GenericName as 'Generic Name', I.BrandName as 'Brand Name'
												from Prescription Pr, Patient P, Includes I
												where P.CareCardNum = '#{ccNum}' AND 
                        Pr.CareCardNum=P.CareCardNum 
                        AND I.PrescriptID=Pr.PrescriptID;")
		@title = "Previous Drugs prescribed to patient# #{ccNum}"
		render "index"
	 end

	 # Check if a certain drug was taken in the past by a certain patient
	 def qD11
	 	ccNum = params[:ccNum]
	 	brandName = params[:brandName]
	 	genericName = params[:genericName]
	 	@result = Table.connection.select_all("select distinct CONCAT(D.FirstName, ' ', D.LastName) as 'Prescribed by', Pr.PrescriptID as 'Prescription ID', Pr.Dosage, Pr.date_prescribed as 'Date Prescribed'
												from Patient P, Prescription Pr, Includes I, Doctor D
												where P.CareCardNum = Pr.CareCardNum and
													P.CareCardNum = '#{ccNum}' and
													Pr.LicenseNum = D.LicenseNum and
													Pr.PrescriptID = I.PrescriptID and
													I.BrandName LIKE '#{brandName}' and
													I.GenericName LIKE '#{genericName}'")
		@title = "All prescriptions of #{brandName}/#{genericName} for patient# #{ccNum}"
		render "index"
	 end

	 # View possible drug interactions
	 def qD12
	 	iGenericName = params[:iGenericName]
	 	# check that generic name is filled
	 	assert {!iGenericName.empty?}
	 	@result = Table.connection.select_all("select iBrandName as 'Brand Name', iGenericName as 'Generic Name'               
																						from InteractsWith                                                              
																						where LCASE(dGenericName) like '%#{iGenericName}%'                                    
																						UNION                 	                                                          
																						select dBrandName as 'Brand Name', dGenericName as 'Generic Name'               
																						from InteractsWith                                                              
																						where LCASE(iGenericName) like '%#{iGenericName}%';   ")
	 	@title = "Possible drug interactions for #{iGenericName}"
		render "index"
	 end

	 # View patient's past appointments
	 def qD13
	 	ccNum = params[:ccNum]
	 	# check that care card number is a non-negative number
	 	assert {ccNum.to_f >= 0}
	 	@result = Table.connection.select_all("select M.TimeMade as 'Time Made', M.DateMade as 'Date Made', CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor',
	 											 	M.TimeBlockDate as 'Date', M.StartTime as 'Start Time', M.EndTime as 'End Time'
												from MakesAppointmentWith M, Doctor D, Patient P
												where D.LicenseNum = M.LicenseNum and
													M.CareCardNum = P.CareCardNum and
													P.CareCardNum = '#{ccNum}' and
													D.LicenseNum = '#{@userlicense}' and
													TimeBlockDate < curdate()")
	 	@title = "Your past appointments with patient# #{ccNum}"
		render "index"
	 end

	 # Generate a report about which prescriptions a doctor has previously prescribed...
	 def qD14
	 	@result = Table.connection.select_all("select Pr.PrescriptID as 'Prescription ID', 
	 												CONCAT(P.FirstName, ' ', P.LastName) as 'Patient Name', 
	 												CONCAT (Dr.BrandName, ' ', Dr.GenericName) as Drug, 
	 												CONCAT(Pm.Address, ', ', Pm.Name) as 'Pharmacy Description' 
											from Prescription Pr, Doctor D, Patient P, Pharmacy Pm, OrderedFrom O, Includes I, Drug Dr
											where 	Pr.LicenseNum = D.LicenseNum and
													Pr.CareCardNum = P.CareCardNum and 
													O.PrescriptID = Pr.PrescriptID and 
													O.PharmacyAddress = Pm.Address and 
													I.PrescriptID = Pr.PrescriptID and
													I.BrandName = Dr.BrandName and
													I.GenericName = Dr.GenericName and
													D.LicenseNum LIKE '#{@userlicense}'")
	 	@title = "Your previously prescribed prescriptions"
		render "index"
	 end

	 # Show the average number of refills for a certain drug
	 def qD15
	 	@result = Table.connection.select_all("select CONCAT(Dr.BrandName, ' ', Dr.GenericName) as 'Drug', AVG(P.Refills) as 'Average number of refills'
											from Prescription P, Drug Dr, Includes I
											where P.PrescriptID = I.PrescriptID and 
													I.BrandName = Dr.BrandName and 
													I.GenericName = Dr.GenericName
											group by Dr.BrandName, Dr.GenericName
											order by AVG(P.Refills) desc, Dr.BrandName, Dr.GenericName")
	 	@title = "Average refills for all drugs"
		render "index"
	 end

 	# View patients who have been prescribed a drug from a specific company
	def qD16
		cName = params[:cName]
		# check that generic name is filled
	 	assert {!cName.empty?}
	 	@result = Table.connection.select_all("select Pa.CareCardNum as 'Care Card Number', CONCAT(Pa.FirstName, ' ', Pa.LastName) as 'Patient Name'
											from Patient Pa
											Where NOT EXISTS
											     (Select *
											      from Drug D
											      Where LCASE(D.CompanyName) LIKE LCASE('#{cName}')
											      AND NOT EXISTS
											      (Select * 
											            From Prescription P, Includes I
											            WHERE P.PrescriptID = I.prescriptID and 
											            		I.BrandName = D.BrandName and
											            		P.CareCardNum = Pa.CareCardNum))")
	 	@title = "Patients who have been prescribed a drug from #{cName}"
		render "index"
	 end

	 # Add a new patient to the database
	 def qD17
	 	pFName = params[:pFName]
	 	pLName = params[:pLName]
	 	pAge = params[:pAge]
	 	pWeight = params[:pWeight]
	 	pHeight = params[:pHeight]
	 	pAddress = params[:pAddress]
	 	pPhoneNum = params[:pPhoneNum]
	 	ccNum = params[:ccNum]

	 	# check that all fields are filled
	 	assert {!pFName.empty?}
	 	assert {!pLName.empty?}
	 	assert {!pAge.empty?}
	 	assert {!pWeight.empty?}
	 	assert {!pHeight.empty?}
	 	assert {!pAddress.empty?}
	 	assert {!pPhoneNum.empty?}
	 	assert {!ccNum.empty?}

	 	# check that age, weight, height, care card number, phone number are non-negative integers
	 	assert {pAge.to_f >= 0}
	 	assert {pWeight.to_f >= 0}
	 	assert {pHeight.to_f >= 0}
	 	assert {pPhoneNum.to_f >= 0}
	 	assert {ccNum.to_f >= 0}

	 	# check that phone number is 10 digits
	 	assert {pPhoneNum.length == 10}

	 	Table.connection.execute("INSERT INTO Patient
									VALUES ('#{ccNum}', '#{pFName}', '#{pLName}', '#{pAge}', '#{pWeight}', '#{pHeight}', 
        							'#{pAddress}', '#{pPhoneNum}')")
	 	@result = Table.connection.select_all("select *
	 											from Patient P
	 											where P.CareCardNum = #{ccNum}")
	 	@title = "#{pFName} #{pLName} added to database with Care Card Number #{ccNum}"
	 	render "index"
	 end


	 # show max number of refills for each drug
  def qD18
  	@result = Table.connection.select_all("select CONCAT(Dr.BrandName, '/', Dr.GenericName) as 'Drug', MAX(P.Refills) as 'Maximum refills'
										  	from Prescription P, Drug Dr, Includes I                                        
										  	where P.PrescriptID = I.PrescriptID and                                         
										  	I.BrandName = Dr.BrandName and                                              
										  	I.GenericName = Dr.GenericName                                              
										  	group by Dr.BrandName, Dr.GenericName                                           
										  	order by MAX(P.Refills) desc, Dr.BrandName, Dr.GenericName")
  	@title = "Maximum refills for each drug"
  	render "index"
  end


	 # show all refills for all drugs (for demo purposes)                         
  def qD19
    @result = Table.connection.select_all("select distinct I.BrandName as 'Brand Name', I.GenericName as 'Generic Name', P.Refills                           
                                            from Includes I, Prescription P                                                 
                                            where I.PrescriptID = P.PrescriptID ") 
    @title = "Refill data for all drugs"
    render "index"
  end       

  # select drug that was prescribed the most for each company 
  def qD20
    @result =  Table.connection.select_all("select Temp.BrandName, Temp.GenericName,Temp.CompanyName, Temp.count
																						from (select D.BrandName, D.GenericName, D.CompanyName, COUNT(*) as 'count'
																						from Drug D, Includes I, Prescription P
																						where P.PrescriptID=I.PrescriptID
																						AND I.BrandName=D.BrandName
																						AND I.GenericName=D.GenericName
																						group by D.BrandName, D.GenericName, D.CompanyName) as Temp
																						Where Temp.count = (Select max(Tempb.count)
																						From (select D.BrandName, D.GenericName, D.CompanyName, COUNT(*) as 'count'
																						from Drug D, Includes I, Prescription P
																						where P.PrescriptID=I.PrescriptID
																						AND I.BrandName=D.BrandName
																						AND I.GenericName=D.GenericName
																						group by D.BrandName, D.GenericName, D.CompanyName) as Tempb)")

    @title = "Drug prescribed the most for each company"
    render "index"
  end  

  # select drug that was prescribed the least for each company 
  def qD20a
  	@result = Table.connection.select_all("select Temp.BrandName, Temp.GenericName,Temp.CompanyName, Temp.count
																						from (select D.BrandName, D.GenericName, D.CompanyName, COUNT(*) as 'count'
																						from Drug D, Includes I, Prescription P
																						where P.PrescriptID=I.PrescriptID
																						AND I.BrandName=D.BrandName
																						AND I.GenericName=D.GenericName
																						group by D.BrandName, D.GenericName, D.CompanyName) as Temp
																						Where Temp.count = (Select min(Tempb.count)
																						From (select D.BrandName, D.GenericName, D.CompanyName, COUNT(*) as 'count'
																						from Drug D, Includes I, Prescription P
																						where P.PrescriptID=I.PrescriptID
																						AND I.BrandName=D.BrandName
																						AND I.GenericName=D.GenericName
																						group by D.BrandName, D.GenericName, D.CompanyName) as Tempb)")
		@title = "Drug prescribed the least for each company"
		render "index"
  end                  
                                                                                 
  # deleting the patient will delete the appts and includes and prescription     
  def qD21
    ccNum = params[:ccNum]
      assert {!ccNum.empty?}
      assert {ccNum.to_f >= 0}
    Table.connection.execute("delete from Patient where CareCardNum='#{ccNum}'")
    @result = Table.connection.select_all("Select Pa.CareCardNum as 'Care Card Number', CONCAT(Pa.FirstName, ' ', Pa.LastName) as 'Patient Name',
                      Address, PhoneNumber as 'Phone Number'
                      from Patient Pa")
    @title = "Patient ##{ccNum} deleted! Displaying everyone else"
    render "index"
  end        

  # View all patients
  def qD22
    @result = Table.connection.select_all("Select Pa.CareCardNum as 'Care Card Number', CONCAT(Pa.FirstName, ' ', Pa.LastName) as 'Patient Name',
                      Address, PhoneNumber as 'Phone Number'
                      from Patient Pa")
    @title = "All patients" 
    render "index"
  end

  # Send to prescription to pharmacy
 def qD23
 	phAddr = params[:phAddr]
 	prescription = params[:prescription]
 	Table.connection.execute("insert into OrderedFrom
								values ('#{prescription}', '#{phAddr}', null)")
 	@result = Table.connection.select_all("select O.PrescriptID, O.PharmacyAddress from OrderedFrom O where O.PrescriptID = '#{prescription}' and O.PharmacyAddress = '#{phAddr}'")
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

def assert &block
	raise Exceptions::AssertionError unless yield
end

# def table_params
# 		params.require(:table).permit(:identity, :var1)
# end
# class AssertionError < RuntimeError
# end

end




