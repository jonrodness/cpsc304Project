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

#result
select * 
from Drug;

########User: Patients

# (qPa1a) Update patient Address
# Address and CareCardNum have variables in tables_controller
# Static variables below as placeholders
update Patient 
	set Address = 'static'
    where CareCardNum LIKE '1234567890';
#result
SELECT CareCardNum as 'Care Card Number', FirstName as 'First Name', 
	LastName as 'Last Name', Age, Weight, Height, Address, 
	PhoneNumber as 'Phone Number' 
FROM Patient 
where CareCardNum LIKE '1234567890';

# (qPa1b) Update patient phone number
# PhoneNumber and CareCardNum have variables in tables_controller
# Static variables below as placeholders
update Patient 
	set PhoneNumber = '0987654321' 
    where CareCardNum LIKE '1234567890';
#result
SELECT CareCardNum as 'Care Card Number', FirstName as 'First Name', 
	LastName as 'Last Name', Age, Weight, Height, Address, 
	PhoneNumber as 'Phone Number' 
FROM Patient 
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
#result
select TIME_FORMAT(MakeApptW.StartTime, '%h:%i%p') as 'Start Time', 
	TIME_FORMAT(MakeApptW.EndTime, '%h:%i%p') as 'End Time', 
	MakeApptW.TimeBlockDate as 'Date', 
	CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', 
	CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' 
from MakesAppointmentWith MakeApptW, Doctor D, Patient P 
where MakeApptW.LicenseNum = D.LicenseNum 
	and MakeApptW.CareCardNum = P.CareCardNum and P.CareCardNum = '1234567890';

# (qPa5) Patients can cancel an appointment they made
# Attributes are variables in tables_controller
# Static variables below as placeholders
delete from MakesAppointmentWith 
where
	CareCardNum = '1234567890' and
	TimeBlockDate = '2015-04-03' and
	StartTime = '09:00:00';
#result
select TIME_FORMAT(MakeApptW.StartTime, '%h:%i%p') as 'Start Time', 
	TIME_FORMAT(MakeApptW.EndTime, '%h:%i%p') as 'End Time', 
	MakeApptW.TimeBlockDate as 'Date', 
	CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', 
	CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' 
from MakesAppointmentWith MakeApptW, Doctor D, Patient P 
where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum 
	and P.CareCardNum = '1234567890';

# (qPa6a) View upcoming appts
# CareCardNum is a variable in tables_controller
# Static variable below as placeholder
select TIME_FORMAT(MakeApptW.StartTime, '%h:%i%p') as 'Start Time', 
	TIME_FORMAT(MakeApptW.EndTime, '%h:%i%p') as 'End Time', 
	MakeApptW.TimeBlockDate as 'Date', 
	CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', 
	CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' 
from MakesAppointmentWith MakeApptW, Doctor D, Patient P 
where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum 
	and P.CareCardNum = '1234567890';

# (qPa6b) View upcoming appointments by date
# CareCardNum, TimeBlockDate have variables in tables_controller
# Static variable below as placeholders
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate, 
	CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', 	
	CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' 
from MakesAppointmentWith MakeApptW, Doctor D, Patient P 
where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum 
	and P.CareCardNum = '1234567890' and MakeApptW.TimeBlockDate = '2015-04-03';

# (qPa6c) View appts during a certain time(optional)
# CareCardNum, StartTime, EndTime have variables in tables_controller
# Static variable below as placeholders
select MakeApptW.StartTime as 'Start Time', MakeApptW.EndTime as 'End Time', 
	MakeApptW.TimeBlockDate as 'Date', CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor', 
	CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on ' 
from MakesAppointmentWith MakeApptW, Doctor D, Patient P 
where MakeApptW.LicenseNum = D.LicenseNum and MakeApptW.CareCardNum = P.CareCardNum and 
	P.CareCardNum = '1234567890' and MakeApptW.StartTime >=  '09:00:00'  
	and MakeApptW.EndTime <=  '11:00:00';

# (qPa7) Check Drug Interactions
# dGenericName, iGenericName, dBrandName and dGenericName have variables 
#in tables_controller
# Static variables below as placeholders
select iBrandName as 'Brand Name', iGenericName as 'Generic Name' 
from InteractsWith 
where LCASE(dGenericName) like '%ibuprofen%'
UNION
select dBrandName as 'Brand Name', dGenericName as 'Generic Name' 
from InteractsWith 
where LCASE(iGenericName) like '%ibuprofen%';

# (qPa8) Check Interactions for this prescriptionID
# PrescriptID has variable in tables_controller
# Static variable below as placeholder
select distinct IW.iBrandName as 'Brand name', IW.iGenericName as 'Generic name' 
from Prescription P, InteractsWith IW, Includes I, Drug D1, Drug D2 
where P.PrescriptID LIKE '0001' and P.PrescriptID = I.PrescriptID 
	and I.BrandName = D1.BrandName and I.GenericName = D1.GenericName 
	and IW.dBrandName = D1.BrandName and IW.dGenericName = D1.GenericName 
	and IW.iBrandName != D1.BrandName and IW.iGenericName != D1.GenericName;



# (qPa9) View Prescription Status (ready or not for pickup)
# CareCardNum is a variable in tables_controller
# Static variable below as placeholder
select Pr.PrescriptID as "Prescription ID" , O.PharmacyAddress
from Prescription Pr, Patient P, OrderedFrom O
where Pr.ReadyForPickup=1 and 
	O.PrescriptID = Pr.PrescriptID and 
	P.CareCardNum LIKE '1234567890';



# (qPa10) Generate a report about what prescriptions a patient is currently using, 
# 	when they were prescribed, and which doctor prescribed them
# CareCardNum is a variable in tables_controller
# Static variable below as placeholder
select distinct Pr.PrescriptID as 'Prescription ID', 
	(Pr.date_prescribed) as 'Date prescribed', CONCAT(D.FirstName, ' ', 
	D.LastName) as 'Prescribed by', 
	CONCAT (Dr.BrandName, ' ', Dr.GenericName) as Drug, Pr.dosage as 'Drug dosage', 
	Pr.refills as 'Refills' 
from Patient P, Prescription Pr, Doctor D, Pharmacy Pm,  Includes I, Drug Dr 
where P.CareCardNum LIKE '1234567890' and 
	P.CareCardNum = Pr.CareCardNum and 
	Pr.LicenseNum = D.LicenseNum 
	and I.PrescriptID = Pr.PrescriptID 
	and I.BrandName = Dr.BrandName 
	and I.GenericName = Dr.GenericName 
	and Pr.refills > 0 
order by Pr.date_prescribed desc;

# (qPa11) second analogous report, but for previous prescriptions (not current)
# CareCardNum is a variable in tables_controller
# Static variable below as placeholder
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

# qPa12 a user can order a prescription from a pharmacy
# TODO 
# WE NEED TO AUTOGENERATE 
# A NUMBER EACH TIME FOR ORDER NUMBER
# OMG HOW DO WE DO THIS
# #OrderedFrom(PrescriptID,PharmacyAddress, OrderNo )
insert into OrderedFrom
	values ('0498', '885 Broadway W, Vancouver, BC V5Z 1J9', '03457436500');
########User: Doctors

# (qD1a) Doctor an update their address
update Doctor 
set Address = 'staticAddress'
where LicenseNum = '1232131241';

# (qD1b) Doctor an update their phone number
update Doctor 
set PhoneNumber = '7789877680'
where LicenseNum = '1232131241';
#result
select LicenseNum as 'License Number', 
	CONCAT(FirstName, ' ', LastName) as 'Doctor Name', Address, 
	PhoneNumber as 'Phone Number', Type 
from Doctor 
where Doctor.LicenseNum='1232131241';

# (qD1c) Update patient height
update Patient 
set Height = '172'
where CareCardNum LIKE '1234567890';
#result
select CareCardNum as 'Care Card Number', FirstName as 'First Name', 
	LastName as 'Last Name', Age, Weight, Height, Address, 
	PhoneNumber as 'Phone Number' 
from Patient
where CareCardNum = '1234567890';

# (qD1d) Update patient weight
update Patient 
set Weight = '179'
where CareCardNum LIKE '1234567890';
#result
select CareCardNum as 'Care Card Number', FirstName as 'First Name', 
	LastName as 'Last Name', Age, Weight, Height, Address, 
	PhoneNumber as 'Phone Number' 
from Patient
where CareCardNum = '1234567890';

# (qD2) can prescribe a drug
insert into Prescription
values ('1232131241','0000','10' ,'Erdday allday for 50 days' ,'1234567890' , 0, NOW());

insert into Includes 
values ('0000', 'Advil', 'Ibuprofen');
#result
SELECT LicenseNum as 'License Number', PrescriptID as 'Prescription ID', 
	Refills, Dosage, CareCardNum as 'Care Card Number', 
	ReadyForPickUp 'Pickup Status', date_prescribed as 'Date Prescribed'
FROM Prescription 
WHERE Prescription.PrescriptID = '0000';

# (qD3) Select pharmacies that are currently open (weekday)
select Address, Name, PhoneNumber, 
	TIME_FORMAT(WeekDayHoursOpening, '%h:%i%p') as 'Weekday Opening', 
	TIME_FORMAT(WeekDayHoursClosing, '%h:%i%p')  as 'Weekday Closing', 
	TIME_FORMAT(WeekendHoursOpening, '%h:%i%p') as 'Weekend Closing', 
	TIME_FORMAT(WeekendHoursClosing, '%h:%i%p') as 'Weekend Closing' 
from Pharmacy P 
where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing;

# (qD4) Select pharmacies that are currently open (weekend)
select Address, Name, PhoneNumber, 
	TIME_FORMAT(WeekDayHoursOpening, '%h:%i%p')  as 'Weekday Opening', 
	TIME_FORMAT(WeekDayHoursClosing, '%h:%i%p')  as 'Weekday Closing', 
	TIME_FORMAT(WeekendHoursOpening, '%h:%i%p') as 'Weekend Closing', 
	TIME_FORMAT(WeekendHoursClosing, '%h:%i%p') as 'Weekend Closing' 
from Pharmacy P 
where curtime() between P.WeekendHoursOpening and P.WeekendHoursClosing;

# (qD5) View Appointments for picked date and time
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(P.FirstName, " ", P.LastName) as "Patient",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		D.LicenseNum  = '1232131241'
order by MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate; 


# (qD6) View Appointments on a certain date
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(P.FirstName, " ", P.LastName) as "Patient",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		D.LicenseNum  = '1232131241' and
		MakeApptW.TimeBlockDate = '2015-04-03';

# (qD7) View Appointments during a certain time
select MakeApptW.StartTime as 'Start Time', MakeApptW.EndTime as 'End Time', 
	MakeApptW.TimeBlockDate as 'Date', 
	CONCAT(P.FirstName, ' ', P.LastName) as 'Patient',  
	CONCAT(MakeApptW.TimeMade, ' ', MakeApptW.DateMade) as 'Appointment made on '
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		D.LicenseNum  = '1232131241' and
		MakeApptW.StartTime >=  '09:00:00'  and
		MakeApptW.EndTime <=  '11:00:00';

# (qD8) View patient information
# example query: view all data about patient number 999
select CareCardNum as 'Care Card Number', FirstName as 'First Name', 
	LastName as 'Last Name', Age, Weight, Height, Address, 
	PhoneNumber as 'Phone Number'
from Patient
where CareCardNum = '1234567890';

# (qD9) Can view a list of previous prescriptions for a certain patient
select CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor Name', 
	 		D.Type as 'Doctor Type', I.BrandName as 'Brand Name',  
	 		P.Dosage, P.date_prescribed as 'Date Prescribed' 
from Doctor D, Prescription P, Includes I  
where P.LicenseNum='1232131241' and I.PrescriptID=P.PrescriptID 
group by D.LastName;



# (qD10) Can view a list of previous drugs taken by a certain patient
select I.GenericName as 'Generic Name', I.BrandName as 'Brand Name'
from Prescription Pr, Patient P, Includes I
where P.CareCardNum= '1234567890' AND Pr.CareCardNum=P.CareCardNum 
	AND I.PrescriptID=Pr.PrescriptID;


# (qD11) Can check if a certain drug was taken in the past by a certain patient
select distinct CONCAT(D.FirstName, ' ', D.LastName) as 'Prescribed by', 
	Pr.PrescriptID as 'Prescription ID', Pr.Dosage, 
	Pr.date_prescribed as 'Date Prescribed'
from Patient P, Prescription Pr, Includes I, Doctor D
where P.CareCardNum = Pr.CareCardNum and
P.CareCardNum = '1234567890' and
Pr.LicenseNum = D.LicenseNum and
Pr.PrescriptID = I.PrescriptID and
I.BrandName LIKE 'Advil' or
I.GenericName LIKE 'Ibuprofen';


# (qD12) View possible drug interactions
select iBrandName as 'Brand Name', iGenericName as 'Generic Name' 
from InteractsWith 
where LCASE(dGenericName) like '%ibuprofen%'
UNION
select dBrandName as 'Brand Name', dGenericName as 'Generic Name' 
from InteractsWith 
where LCASE(iGenericName) like '%ibuprofen%';


# (qD13) Can view a list of past appointments by a certain patient
select M.TimeMade as 'Time Made', M.DateMade as 'Date Made', CONCAT(D.FirstName, ' ', D.LastName) as 'Doctor',
 	M.TimeBlockDate as 'Date', M.StartTime as 'Start Time', M.EndTime as 'End Time'
from MakesAppointmentWith M, Doctor D, Patient P
where D.LicenseNum = M.LicenseNum and
M.CareCardNum = P.CareCardNum and
P.CareCardNum = '1234567890' and
D.LicenseNum = '2743873823' and
TimeBlockDate < curdate();

# (qD14) Generate a report about which prescriptions a doctor 
#has previously prescribed
# 	sample, doctor's license num = '1232131241'
select Pr.PrescriptID as 'Prescription ID', 
	CONCAT(P.FirstName, ' ', P.LastName) as 'Patient Name', 
	CONCAT (Dr.BrandName, ' ', Dr.GenericName) as Drug, 
	CONCAT(Pm.Address, ', ', Pm.Name) as 'Pharmacy Description' 
from Prescription Pr, Doctor D, Patient P, Pharmacy Pm, OrderedFrom O, 
	Includes I, Drug Dr
where 	Pr.LicenseNum = D.LicenseNum and
	Pr.CareCardNum = P.CareCardNum and 
	O.PrescriptID = Pr.PrescriptID and 
	O.PharmacyAddress = Pm.Address and 
	I.PrescriptID = Pr.PrescriptID and
	I.BrandName = Dr.BrandName and
	I.GenericName = Dr.GenericName and
	D.LicenseNum LIKE '1232131241';

# (qD15) Show the average number of refills for all drugs
select CONCAT(Dr.BrandName, " ", Dr.GenericName) as "Drug", AVG(P.Refills) as "Average number of refills"
from Prescription P, Drug Dr, Includes I
where P.PrescriptID = I.PrescriptID and 
		I.BrandName = Dr.BrandName and 
		I.GenericName = Dr.GenericName
group by Dr.BrandName, Dr.GenericName
order by AVG(P.Refills) desc, Dr.BrandName, Dr.GenericName;


# (qD16) Select patients who ordered all products by company name = Pfizer
select Pa.CareCardNum as 'Care Card Number', 
	CONCAT(Pa.FirstName, ' ', Pa.LastName) as 'Patient Name'
from Patient Pa
Where NOT EXISTS
     (Select *
      from Drug D
      Where LCASE(D.CompanyName) LIKE LCASE('pfizer')
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