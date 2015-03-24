########User: Pharmacists

# Q1 view prescriptions prescribed by doctor
#chris-checked
select Pr.PrescriptID
from Prescription Pr, Doctor D
where Pr.LicenseNum=D.LicenseNum;

# Q2 change status of prescription (not ready for pick up, ready for pick up) (**need to add as attribute)
#chris-checked
update Prescription
    set ReadyForPickUp=1
    where PrescriptID ='3456' AND ReadyForPickup=0;

#can view past prescriptions for patient
#chris-checked
select Pr.date_prescribed,I.GenericName,Pr.Refills,Pr.Dosage
from Prescription Pr, Patient P, Includes I
where Pr.CareCardNum=P.CareCardNum AND I.PrescriptID=Pr.PrescriptID AND Pr.CareCardNum=1234567890
Order By Pr.date_prescribed;

#can print out a list of prescriptions filled that day
#chris-checked
select I.GenericName, Pr.Dosage
from Prescription Pr, Patient P, Includes I
where Pr.PrescriptID=I.PrescriptID AND Pr.CareCardNum=P.CareCardNum AND Pr.date_prescribed=curdate();

#can reduce the refill number of a patient’s prescription
#chris-checked
update Prescription
    set Refills=Refills-1
    where PrescriptID='3456' AND Refills > 0;

########User: Patients

# ----update personal information about him/herself
# anny-checked
#	?????? so many possible attributes to update?
#	 sample query: patient carecard num = 1234567890
#	 store all attrs of the patient in some variables
#	 in our query, either set the attribute to a new value that the user entered, or the old value that we stored in variables
select*
from Patient P 
where P.CareCardNum LIKE '1234567890'

update Patient
set FirstName = 'blabla',
    LastName = 'blabla',
    Age = 'blabla',
    Weight = 'blabla',
    Height = 'blabla',
    Address = 'blabla',
    PhoneNumber = 'blabla'
where P.CareCardNum LIKE '1234567890'; 


#select pharmacies that are currently open
#chris--in one query or 2?
select *
from Pharmacy P
where curtime() between P.WeekdayHoursOpening and P.WeekdayHoursClosing;
# based on the day of the week, use one or the other query 
#select pharmacies that are currently open
#chris
select *
from Pharmacy P
where curtime() between P.WeekendHoursOpening and P.WeekendHoursClosing;


#can create an appointment with any doctor at any given time, as long
# anny-checked
# 	 as the doctor is available during that time and the appointment is within business hours
# 	first, we gotta create a timeblock tuple 
# 	second, recall MakesAppointmentWith(TimeMade, DateMade,LicenseNum,TimeBlockDate, StartTime, EndTime, CareCardNum)
insert into TimeBlock
values (
		'2874-06-07',
		'12:30:00',
		'15:30:00'
);
insert into MakesAppointmentWith
values (
		curdate(),
		curtime(),
		'1232131241',
		'2874-06-07',
		'12:30:00',
		'15:30:00',
		'1234567890'
		);

#can cancel an appointment they made, by looking at the list of self booked appointments
# checked
delete from MakesAppointmentWith 
where
	CareCardNum = '1234567890' and
	TimeBlockDate = '2015-04-03' and
	StartTime = '09:00:00';


#----can view upcoming appointments, on a certain date(optional) and during a certain time(optional)
# 3 queries
# 1) view upcoming appts
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(D.FirstName, " ", D.LastName) as "Doctor",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		P.CareCardNum = '1234567890';

# 2) view appts on a certain date(optional), sample date = '2015-04-03'
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(D.FirstName, " ", D.LastName) as "Doctor",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		P.CareCardNum = '1234567890' and
		MakeApptW.TimeBlockDate = '2015-04-03';
# 3) view appts during a certain time(optional)
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(D.FirstName, " ", D.LastName) as "Doctor",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		P.CareCardNum = '1234567890' and
		MakeApptW.StartTime >=  '09:00:00'  and
		MakeApptW.StartTime <=  '11:00:00';



#----can view a list of drugs that interact with a specific drug
# chris-checked
# example query: select the generic name of all drugs that interact with Ibuprofen
select dGenericName
from InteractsWith
where iGenericName like '%Ibuprofen%'
UNION
select iGenericName
from InteractsWith
where dGenericName like '%Ibuprofen%';

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


#----can view all prescriptions that are ready for pickup
#checked
select Pr.PrescriptID as "Prescription ID" , O.PharmacyAddress
from Prescription Pr, Patient P, OrderedFrom O
where Pr.ReadyForPickup=1 and 
	O.PrescriptID = Pr.PrescriptID and 
	P.CareCardNum LIKE '1234567890';

#----Generate a report about what prescriptions a patient is currently using, 
# anny:checked
# 	generate a report about prescriptions for a patient, when they were prescribed, which doctor prescribed them
# 	the most recent on the top	
# 	sample patient license num: '1234567890'

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

        


# --- second analogous report, but for previous prescriptions (not current)
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

#-----can update personal information about him/herself
#checked
select *
from Doctor
where
	LicenseNum = '1232131241';


update Doctor
set
	FirstName = 'bla',
	LastName = 'bla',
	Address = 'bla',
	PhoneNumber = 7789877680,
	Type = "Super cool doctor type"
where
	LicenseNum = '1232131241';

#-----can prescribe a drug
#chris--checked
#licensenum= 1232131241
#carecardnum = 1234567890
# Prescription (LicenseNum, PrescriptID,Refills,Dosage,CareCardNum,ReadyForPickUp,date_prescribed)

insert into Prescription
values ('1232131241','0000','10' ,'Erdday allday for 50 days' ,'1234567890' , 0, NOW());


#----can view a list of all appointments for any picked date and any picked time
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(P.FirstName, " ", P.LastName) as "Patient",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		D.LicenseNum  = '1232131241'
order by MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate; 

#---- 2) view appts on a certain date(optional), sample date = '2015-04-03'
select MakeApptW.StartTime, MakeApptW.EndTime, MakeApptW.TimeBlockDate,
		CONCAT(P.FirstName, " ", P.LastName) as "Patient",  
	CONCAT(MakeApptW.TimeMade, " ", MakeApptW.DateMade) as "Appointment made on "
from MakesAppointmentWith MakeApptW, Doctor D, Patient P
where MakeApptW.LicenseNum = D.LicenseNum and
		MakeApptW.CareCardNum = P.CareCardNum and
		D.LicenseNum  = '1232131241' and
		MakeApptW.TimeBlockDate = '2015-04-03';
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

#-----can view personal information about a patient 
# example query: view all data about patient number 999
select *
from Patient
where CareCardNum=999;
# doctor should be able to see a list of previous/current prescriptions for a patient
#	the query is already implemented above

#-----can view a list of previous drugs taken by a certain patient
#chris
select I.GenericName
from Prescription Pr, Patient P, Includes I
where P.CareCardNum= '1234567890' AND Pr.CareCardNum=P.CareCardNum AND I.PrescriptID=Pr.PrescriptID;

#can check if a certain drug was taken in the past by a certain patient
# 	anny:checked
select Pr.LicenseNum as "Prescribed by", Pr.PrescriptID as "Prescription ID", Pr.Dosage, Pr.date_prescribed
from Patient P, Prescription Pr, Includes I
where P.CareCardNum = Pr.CareCardNum and
	P.CareCardNum = '1234567890' and
	Pr.PrescriptID = I.PrescriptID and
	I.BrandName LIKE 'BLABLA' or
	I.GenericName LIKE 'blabla';
		



#can view a list of drugs that interact with a specific drug  (same as patient)
#chris-checked
select D.GenericName, D.BrandName
from InteractsWith I, Drug D
where (I.dBrandName = 'Coumadin' and
		I.dGenericName = 'Warfarin' and
		I.iGenericName = D.GenericName and
		I.iBrandName = D.BrandName) or
		(I.iBrandName = 'Coumadin' and
		I.iGenericName = 'Warfarin' and
		I.dBrandName = D.BrandName and
		I.dGenericName = D.GenericName);


#can view a list of past appointments by a certain patient
#chris-checked
select *
from MakesAppointmentWith M, Doctor D, Patient p
where D.LicenseNum=M.LicenseNum and
	M.CareCardNum = P.CareCardNum and
	TimeBlockDate < curdate();


#----Generate a report about which prescriptions a doctor has
#   previously prescribed, and to whom the prescriptions were prescribed, as well as which pharmacy filled the prescription
# 	sample, doctor's license num = '1232131241'

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


# show the average number of refills for a certain drug
#checked - need this query to pass the "aggregation query" check
select CONCAT(Dr.BrandName, " ", Dr.GenericName) as "Drug", AVG(P.Refills) as "Average number of refills"
from Prescription P, Drug Dr, Includes I
where P.PrescriptID = I.PrescriptID and 
		I.BrandName = Dr.BrandName and 
		I.GenericName = Dr.GenericName
group by Dr.BrandName, Dr.GenericName
order by AVG(P.Refills) desc, Dr.BrandName, Dr.GenericName;


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




