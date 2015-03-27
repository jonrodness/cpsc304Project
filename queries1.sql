########User: Pharmacists

# (qPh1) View prescriptions prescribed by doctor
select CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor Name', 
	D.Type as 'Doctor Type', I.BrandName as 'Brand Name',  
	P.Dosage, P.date_prescribed as 'Date Prescribed' 
from Doctor D, Prescription P, Includes I  
where D.LicenseNum=P.LicenseNum and I.PrescriptID=P.PrescriptID 
group by D.LastName;

# (qPh2) Change status of prescription (not ready changed to ready for pick up)
# PrescriptID has variable in tables_controller, static variable=3456
update Prescription
    set ReadyForPickUp=1
    where PrescriptID ='3456' AND ReadyForPickup=0;

# (qPh3) Can view past prescriptions for patient
# CareCardNum has variable in tables_controller, 
# Static variable below as placeholders

select Pr.date_prescribed as 'Date Prescribed',I.GenericName as 'Generic Name',
	Pr.Refills,Pr.Dosage
from Prescription Pr, Patient P, Includes I
where Pr.CareCardNum = P.CareCardNum AND I.PrescriptID=Pr.PrescriptID AND 
	Pr.CareCardNum = 1234567890
Order By Pr.date_prescribed;

# (qPh4) Can get a list of prescriptions filled that day
select Pr.PrescriptID as 'Prescription ID', I.GenericName as 'Generic Name', 
	Pr.Dosage 
from Prescription Pr, Patient P, Includes I 
where Pr.PrescriptID=I.PrescriptID and Pr.CareCardNum = P.CareCardNum and 
	Pr.date_prescribed = curdate() ;

# (qPh5) Can reduce the refill number of a patient’s prescription
# PrescriptID has variable in tables_controller
# Static variable below as placeholders
update Prescription
    set Refills=Refills-1
    where PrescriptID='3456' AND Refills > 0;

# (qPh6) Show all drugs in the database
select BrandName as 'Brand Name', GenericName as 'Generic Name', 
	CompanyName as 'Company Name', Price 
from Drug

# (qPh7) Delete a drug from the database, the delete will be rejected 
# BrandName and GenericName have variables in tables_controller, 
# Static variables below as placeholders
delete 
	from Drug
	where BrandName = 'Advil' and
		GenericName = 'Ibuprofen';

########User: Patients

# (qPa1a) Update patient Address
# Address and CareCardNum have variables in tables_controller
# Static variables below as placeholders
update Patient 
	set Address = 'static'
    where CareCardNum LIKE '1234567890';

# (qPa1b) Update patient phone number
# PhoneNumber and CareCardNum have variables in tables_controller
# Static variables below as placeholders
update Patient 
	set PhoneNumber = '0987654321' 
    where CareCardNum LIKE '1234567890';

# (qPa2) Select pharmacies that are currently open (weekday)
select Address, Name, PhoneNumber, 
	TIME_FORMAT(WeekDayHoursOpening, '%h:%i%p') as 'Weekday Opening', 
	TIME_FORMAT(WeekDayHoursClosing, '%h:%i%p')  as 'Weekday Closing', 
	TIME_FORMAT(WeekendHoursOpening, '%h:%i%p') as 'Weekend Closing', 
	TIME_FORMAT(WeekendHoursClosing, '%h:%i%p') as 'Weekend Closing' 
from Pharmacy P 
where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing;

# (qPa3) Select pharmacies that are currently open (weekend)
select Address, Name, PhoneNumber, 
	TIME_FORMAT(WeekDayHoursOpening, '%h:%i%p')  as 'Weekday Opening', 
	TIME_FORMAT(WeekDayHoursClosing, '%h:%i%p')  as 'Weekday Closing', 
	TIME_FORMAT(WeekendHoursOpening, '%h:%i%p') as 'Weekend Closing', 
	TIME_FORMAT(WeekendHoursClosing, '%h:%i%p') as 'Weekend Closing' 
from Pharmacy P 
where curtime() between P.WeekendHoursOpening and P.WeekendHoursClosing;

#given a date/time, view pharmacies that are open at that date/time
	# implemented above


# (qPa4) Can create an appointment with any doctor
# TimeBlock and MakesAppointmentWith attributes are variables in tables_controller
# Static variables below as placeholders
insert into TimeBlock
values (
		'2874-06-07',
		'12:30:00',
		'15:30:00'
		);

insert into MakesAppointmentWith
values (
		curtime(),
		curdate(),
		'1232131241',
		'2874-06-07',
		'12:30:00',
		'15:30:00',
		'1234567890'
		);

# (qPa5) Patients can cancel an appointment they made
# Attributes are variables in tables_controller
# Static variables below as placeholders
delete from MakesAppointmentWith 
where
	CareCardNum = '1234567890' and
	TimeBlockDate = '2015-04-03' and
	StartTime = '09:00:00';


# (qPa6a) View upcoming appts
# CareCardNum is a variable in tables_controller
# Static variable below as placeholders
select TIME_FORMAT(MakeApptW.StartTime, '%h:%i%p') as 'Start Time', 
	TIME_FORMAT(MakeApptW.EndTime, '%h:%i%p') as 'End Time', 
	MakeApptW.TimeBlockDate as 'Date', 
	CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', 
	CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' 
from MakesAppointmentWith MakeApptW, Doctor D, Patient P 
where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum 
	and P.CareCardNum = '1234567890';


# (qPa6b) View upcoming appointments by date
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(D.FirstName, " ", D.LastName) as "Doctor",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		P.CareCardNum = '1234567890' and
		MakeApptW.TimeBlockDate = '2015-04-03';
# 3) qPa6c - view appts during a certain time(optional)
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(D.FirstName, " ", D.LastName) as "Doctor",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		P.CareCardNum = '1234567890' and
		MakeApptW.StartTime >=  '09:00:00'  and
		MakeApptW.StartTime <=  '11:00:00';

# qPa7 - can (quickly)check if he/she took a certain drug before
#----can view a list of drugs that interact with a specific drug
# chris-checked
# example query: select the generic name of all drugs that interact with Ibuprofen
# jon - checked: entered,  add variables
select dGenericName
from InteractsWith
where iGenericName like '%Ibuprofen%'
UNION
select iGenericName
from InteractsWith
where dGenericName like '%Ibuprofen%';

# qPa8 - can input a prescription ID and view a list of drugs that interact with this prescription
	/*
	# example: find all drugs that interact with the drug prescribed in prescription 99
	select
	from Prescription p, InteractsWith iw
	where p.
	*/ -- ^Don't think this query is possible given our schema -Alfred
	# jon - checked: entered, add variables
#can input a prescription ID and view a list of drugs that interact with this prescription
#checked and doneeee
select distinct IW.iBrandName as "Brand name" , IW.iGenericName as "Generic name"
from Prescription P, InteractsWith IW, Includes I, Drug D1, Drug D2
where 	P.PrescriptID LIKE '0001' and
		P.PrescriptID = I.PrescriptID and
		I.BrandName = D1.BrandName and
		I.GenericName = D1.GenericName and

		IW.dBrandName = D1.BrandName and
		IW.dGenericName = D1.GenericName and

		IW.iBrandName != D1.BrandName and
		IW.iGenericName != D1.GenericName;


# qPa9 - can view status of prescription pick up (ready or not for pickup)
#jon: checked: - CHANGE TO FIRST QUERY
#----can view all prescriptions that are ready for pickup
#checked
select Pr.PrescriptID as "Prescription ID" , O.PharmacyAddress
from Prescription Pr, Patient P, OrderedFrom O
where Pr.ReadyForPickup=1 and 
	O.PrescriptID = Pr.PrescriptID and 
	P.CareCardNum LIKE '1234567890';
-- select *
-- from Prescription
-- where ReadyForPickup=1;


# qPa10----Generate a report about what prescriptions a patient is currently using, 
# 	when they were prescribed, and which doctor prescribed them, as well as which pharmacies have them in stock currently
# 	the last part is impossible, we dont have that kind of info
# 	and we cant differentiate between prescriptions patient took vs taking now
# anny:checked
# 	generate a report about prescriptions for a patient, when they were prescribed, which doctor prescribed them
# 	the most recent on the top	
# 	sample patient license num: '1234567890'
# jon: checked: entered, add variables

select distinct Pr.PrescriptID as "Prescription ID", (Pr.date_prescribed) as "Date prescribed", 
        CONCAT(D.FirstName, " ", D.LastName) as "Prescribed by", CONCAT (Dr.BrandName, " ", Dr.GenericName) as Drug,
        Pr.dosage as "Drug dosage",  Pr.refills as "Refills"
from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr
where 	P.CareCardNum LIKE '1234567890' and
		P.CareCardNum = Pr.CareCardNum and 
		Pr.LicenseNum = D.LicenseNum and 
		I.PrescriptID = Pr.PrescriptID and
		I.BrandName = Dr.BrandName and
		I.GenericName = Dr.GenericName and
		Pr.refills > 0

order by Pr.date_prescribed desc;

        


# qPa11--- second analogous report, but for previous prescriptions (not current)
# jon: checked: entered, add variables
select distinct Pr.PrescriptID as "Prescription ID", (Pr.date_prescribed) as "Date prescribed", 
		CONCAT(D.FirstName, " ", D.LastName) as "Prescribed by", CONCAT (Dr.BrandName, " ", Dr.GenericName) as Drug,
		Pr.dosage as "Drug dosage",  Pr.refills as "Refills"
from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr
where 	P.CareCardNum LIKE '1234567890' and
		P.CareCardNum = Pr.CareCardNum and 
		Pr.LicenseNum = D.LicenseNum and 
		I.PrescriptID = Pr.PrescriptID and
		I.BrandName = Dr.BrandName and
		I.GenericName = Dr.GenericName and
		Pr.refills = 0
order by Pr.date_prescribed desc;


########User: Doctors

# qD1 - can update personal information about him/herself
# jon: checked: entered, add variables, ADD SECOND QUERY?
#-----can update personal information about him/herself
#checked


update Doctor
set
	FirstName = 'bla',
	LastName = 'bla',
	Address = 'bla',
	PhoneNumber = 7789877680,
	Type = "Super cool doctor type"
where
	LicenseNum = '1232131241';

select *
from Doctor
where
	LicenseNum = '1232131241'	;


# qD2 can prescribe a drug
#chris--need to put variable names laters
# jon: checked: entered, add variables -LOOK AT AGAIN, MAY NEED TO CHANGE
#-----can prescribe a drug
#chris--checked
#licensenum= 1232131241
#carecardnum = 1234567890
# Prescription (LicenseNum, PrescriptID,Refills,Dosage,CareCardNum,ReadyForPickUp,date_prescribed)

insert into Prescription
values ('1232131241','0000','10' ,'Erdday allday for 50 days' ,'1234567890' , 0, NOW());


#same as the patient ^^^
#can view a list of pharmacies that are open at the moment
	# already done


#can view a list of pharmacies that are open on a certain date and time(optional)
# pD3 & pD4
	# already done
# jon -checked: entered, reformat

#can input an address and a radius and as a result, can view a list of pharmacies that are open at the moment , within the indicated radius of the indicated address
	# too hard

#can view a list of all appointments for any picked date and any picked time
# qD5
# jon -checked: entered, add variables
#----can view a list of all appointments for any picked date and any picked time
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(P.FirstName, " ", P.LastName) as "Patient",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		D.LicenseNum  = '1232131241'
order by MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate; 


# qD6
# jon -checked: entered, add variables
# 2) view appts on a certain date(optional), sample date = '2015-04-03'
#---- 2) view appts on a certain date(optional), sample date = '2015-04-03'
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(P.FirstName, " ", P.LastName) as "Patient",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		D.LicenseNum  = '1232131241' and
		MakeApptW.TimeBlockDate = '2015-04-03';

# qD7
# jon -checked: entered, add variables
# 3) view appts during a certain time(optional)
#---- 3) view appts during a certain time(optional)
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(P.FirstName, " ", P.LastName) as "Patient",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		D.LicenseNum  = '1232131241' and
		MakeApptW.StartTime >=  '09:00:00'  and
		MakeApptW.StartTime <=  '11:00:00';


#can register a patient who requested his/her services
	# nope

# qD8 - can view personal information about a patient 
# jon -checked: entered, add variables
#-----can view personal information about a patient 
# example query: view all data about patient number 999
select *
from Patient
where CareCardNum=999;
# doctor should be able to see a list of previous/current prescriptions for a patient
#	the query is already implemented above

# qD9 -can view a list of previous prescriptions for a certain patient
# jon - checked: entered, ensure only for this doctor's patients
#	same as Q1
select Pr.PrescriptID 
from Prescription Pr, Doctor D, Patient P 
where Pr.LicenseNum = D.LicenseNum and
P.CareCardNum = '#{ccNum}'


# qD10 - can view a list of previous drugs taken by a certain patient
#-----can view a list of previous drugs taken by a certain patient
#chris
# jon - checked: entered, ensure only for this doctor's patients
select I.GenericName
from Prescription Pr, Patient P, Includes I
where P.CareCardNum= '1234567890' AND Pr.CareCardNum=P.CareCardNum AND I.PrescriptID=Pr.PrescriptID;


#old NEED TO UPDATE TO NEXT ONE
-- # qD11 - can check if a certain drug was taken in the past by a certain patient
-- # jon - checked: entered, ensure only for this doctor's patients
-- select distinct Pr.PrescriptID as "Prescription ID", (Pr.date_prescribed) as "Date prescribed", 
-- 		CONCAT(D.FirstName, " ", D.LastName) as "Prescribed by", CONCAT (Dr.BrandName, " ", Dr.GenericName) as Drug,
-- 		Pr.dosage as "Drug dosage"
-- from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr
-- where 	P.CareCardNum LIKE '1234567890' and
-- 		P.CareCardNum = Pr.CareCardNum and 
-- 		Pr.LicenseNum = D.LicenseNum and 
-- 		I.PrescriptID = Pr.PrescriptID and
-- 		I.BrandName = Dr.BrandName and
-- 		I.GenericName = Dr.GenericName and
-- 		Pr.refills = 0
-- order by Pr.date_prescribed desc;
#can check if a certain drug was taken in the past by a certain patient
# 	anny:checked
# jon - change!
select Pr.LicenseNum as "Prescribed by", Pr.PrescriptID as "Prescription ID", Pr.Dosage, Pr.date_prescribed
from Patient P, Prescription Pr, Includes I
where P.CareCardNum = Pr.CareCardNum and
	P.CareCardNum = '1234567890' and
	Pr.PrescriptID = I.PrescriptID and
	I.BrandName LIKE 'BLABLA' or
	I.GenericName LIKE 'blabla';


-- # qD12 - can view a list of drugs that interact with a specific drug  (same as patient)
-- #chris
-- # jon - checked: entered, column names are not working
-- select I.iGenericName


#can view a list of drugs that interact with a specific drug  (same as patient)
#chris-checked
#jon -change!!
select D.GenericName, D.BrandName
from InteractsWith I, Drug D
where (I.dGenericName = 'Warfarin' and
		I.iGenericName = D.GenericName) or
		(I.iGenericName = 'Warfarin' and
		I.dGenericName = D.GenericName);


-- #notified when patients cancel an appointment
-- 	# hmmm? probs we can just do this at the application level, idk

#old NEED TO CHANGE TO NEXT ONE
-- # qD13
-- #can view a list of past appointments by a certain patient
-- #chris
-- # jon - checked: entered, works, but need to select more attributes?
-- select M.DateMade
-- from MakesAppointmentWith M, Doctor D
-- where D.LicenseNum=M.LicenseNum;

#can view a list of past appointments by a certain patient
#chris-checked
# jon - change!!
select *
from MakesAppointmentWith M, Doctor D, Patient p
where D.LicenseNum=M.LicenseNum and
	M.CareCardNum = P.CareCardNum and
	TimeBlockDate < curdate();


# qD14----Generate a report about which prescriptions a doctor has
#   previously prescribed, and to whom the prescriptions were prescribed, as well as which pharmacy filled the prescription
# 	sample, doctor's license num = '1232131241'
# jon - checked: entered, works, add variables
select Pr.PrescriptID, CONCAT(P.FirstName, " ", P.LastName) as PatientName, CONCAT (Dr.BrandName, " ", Dr.GenericName) as Drug, CONCAT(Pm.Address, ", ", Pm.Name) as PharmacyDescription 
from Prescription Pr, Doctor D, Patient P, Pharmacy Pm, OrderedFrom O, Includes I, Drug Dr
where 	Pr.LicenseNum = D.LicenseNum and
		Pr.CareCardNum = P.CareCardNum and 
		O.PrescriptID = Pr.PrescriptID and 
		O.PharmacyAddress = Pm.Address and 
		I.PrescriptID = Pr.PrescriptID and
		I.BrandName = Dr.BrandName and
		I.GenericName = Dr.GenericName and
		D.LicenseNum LIKE '1232131241';


# qD15 - show the average number of refills for all drugs
# jon - checked: entered, works
# show the average number of refills for a certain drug
#checked - need this query to pass the "aggregation query" check
select CONCAT(Dr.BrandName, " ", Dr.GenericName) as "Drug", AVG(P.Refills) as "Average number of refills"
from Prescription P, Drug Dr, Includes I
where P.PrescriptID = I.PrescriptID and 
		I.BrandName = Dr.BrandName and 
		I.GenericName = Dr.GenericName
group by Dr.BrandName, Dr.GenericName
order by AVG(P.Refills) desc, Dr.BrandName, Dr.GenericName;


# qD16 - select patients who ordered all products by company name = Pfizer
# jon - checked: entered, add variables
# select patients who ordered all products by company name = Pfizer
#checked - need this query to pass the "division query" check
select Pa.CareCardNum, Pa.FirstName
from Patient Pa
Where NOT EXISTS
     (Select *
      from Drug D
      Where D.CompanyName LIKE 'Pfizer'
      AND NOT EXISTS
      (Select * 
            From Prescription P, Includes I
            WHERE P.PrescriptID = I.prescriptID and 
            		I.BrandName = D.BrandName and
            		P.CareCardNum = Pa.CareCardNum));

# qD18a - show max number of refills for each drug
# TODO
select CONCAT(Dr.BrandName, " ", Dr.GenericName) as "Drug", MAX(P.Refills) as "MAX number of refills"
from Prescription P, Drug Dr, Includes I
where P.PrescriptID = I.PrescriptID and 
		I.BrandName = Dr.BrandName and 
		I.GenericName = Dr.GenericName
group by Dr.BrandName, Dr.GenericName
order by MAX(P.Refills) desc, Dr.BrandName, Dr.GenericName;

#qD18b show all refils for all drugs (for demo purposes)
# TODO
select distinct I.BrandName, I.GenericName, P.Refills 
from Includes I, Prescription P 
where I.PrescriptID = P.PrescriptID;



# qD19
# select drugs that have the highest/lowest amounts of prescriptions

CREATE VIEW Temp as
select D.BrandName, D.GenericName, D.CompanyName, COUNT(*) as "count"
		from Drug D, Includes I, Prescription P
		where P.PrescriptID=I.PrescriptID 
		AND I.BrandName=D.BrandName 
		AND I.GenericName=D.GenericName
		group by D.BrandName, D.GenericName, D.CompanyName;
select Temp.BrandName, Temp.GenericName,Temp.CompanyName, Temp.count
from Temp
Where Temp.count = (Select min(Temp.count)
					From Temp);
select Temp.BrandName, Temp.GenericName,Temp.CompanyName, Temp.count
from Temp
Where Temp.count = (Select max(Temp.count)
					From Temp);


# qD20
# deleting the patient will delete the appts and includes and prescription
delete from Patient 
	where CareCardNum='1099282394';


----------------------------------------
#RECENT CHANGES BY JON 
----------------------------------------

# removed update patient information (qPa1)
# removed update doctor information (qD1)


 # Update patient address
	     # TESTED - WORKS
	 def qPa1a
	 	pAddress = params[:pAddress]
	 	Table.connection.execute("update Patient set Address = '#{pAddress}'
                                where CareCardNum LIKE '#{@userCCNum}'")
    	@result = Table.connection.select_all("SELECT * FROM Patient where CareCardNum LIKE '#{@userCCNum}'")
	 	render "index"
	 end

	 # Update patient phone number
	     # TESTED - WORKS
	 def qPa1b
	 	pPhoneNum = params[:pPhoneNum]
	 	Table.connection.execute("update Patient set PhoneNumber = '#{pPhoneNum}' 
                                where CareCardNum LIKE '#{@userCCNum}'")
    	@result = Table.connection.select_all("SELECT * FROM Patient where CareCardNum LIKE '#{@userCCNum}'")
	 	render "index"
	 end

	 # Update doctor address
	 	# TESTED - WORKS
	 def qD1a
	 	dAddress = params[:dAddress]
	 	Table.connection.execute("update Doctor set Address = '#{dAddress}'")
	 	@result = Table.connection.select_all("select * from Doctor where LicenseNum = '#{@userlicense}'")
		render "index"
	 end

	 # Update doctor phone number
	 	# TESTED - WORKS
	 def qD1b
	 	dPhoneNum = params[:dPhoneNum]
	 	Table.connection.execute("update Doctor set PhoneNumber = '#{dPhoneNum}'")
	 	@result = Table.connection.select_all("select * from Doctor where LicenseNum = '#{@userlicense}'")
		render "index"
	 end

	 # Update patient height
	 	# TESTED - WORKS
	 def qD1c
	 	pHeight = params[:pHeight]
	 	ccNum = params[:ccNum]
	 	Table.connection.execute("update Patient set Height = '#{pHeight}'
                                where CareCardNum LIKE '#{ccNum}'")
    	@result = Table.connection.select_all("select *
												from Patient
												where CareCardNum = '#{ccNum}'")
	 	render "index"
	 end

	 # Update patient weight
	 	 	# TESTED - WORKS
	 def qD1d
	 	pWeight = params[:pWeight]
	 	ccNum = params[:ccNum]
	 	Table.connection.execute("update Patient set Weight = '#{pWeight}'
                                where CareCardNum LIKE '#{ccNum}'")
    	@result = Table.connection.select_all("select *
												from Patient
												where CareCardNum = '#{ccNum}'")
	 	render "index"
	 end

	 	 # Add a new patient to the database
	 	# TESTED - WORKS
	 def qD17
	 	pFName = params[:pFName]
	 	pLName = params[:pLName]
	 	pAge = params[:pAge]
	 	pWeight = params[:pWeight]
	 	pHeight = params[:pHeight]
	 	pAddress = params[:pAddress]
	 	pPhoneNum = params[:pPhoneNum]
	 	ccNum = params[:ccNum]
	 	Table.connection.execute("INSERT INTO Patient
									VALUES ('#{ccNum}', '#{pFName}', '#{pLName}', '#{pAge}', '#{pWeight}', '#{pHeight}', 
        							'#{pAddress}', '#{pPhoneNum}')")
	 	@result = Table.connection.select_all("select *
	 											from Patient P
	 											where P.CareCardNum = #{ccNum}")
	 	render "index"
	 end
