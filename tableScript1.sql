
drop database PrescriptApp_development;
create database PrescriptApp_development;
    use PrescriptApp_development;

drop table MakesAppointmentWith;
drop table OrderedFrom;
drop table InteractsWith;
drop table Includes;
drop table Prescription;
drop table Doctor;
drop table Patient;
drop table Drug;
drop table Pharmacy;
drop table TimeBlock;


# ---------------- CREATION ---------------- #

#Doctor(LicenseNum, FirstName, LastName,Address, PhoneNumber, Type)
CREATE TABLE Doctor 
    (LicenseNum VARCHAR(20),
    FirstName VARCHAR(20),
    LastName VARCHAR(20),
    Address VARCHAR(50),
    PhoneNumber char(10),
    Type VARCHAR(20),
    PRIMARY KEY (LicenseNum),
    UNIQUE  (Address, FirstName, LastName));

grant select on Doctor to public;

#Patient(CareCardNum,FirstName,LastName,Age,Weight,Height,Address,PhoneNumber )
 CREATE TABLE Patient
    (CareCardNum CHAR(10),
    FirstName VARCHAR(20),    
    LastName VARCHAR(20), 
    Age INT,
    Weight INT,
    Height INT,
    Address VARCHAR(50),
    PhoneNumber CHAR(10), 
    PRIMARY KEY (CareCardNum),
    UNIQUE (Address, FirstName, LastName));

grant select on Patient to public;               

#tinyint 0 false, 1 true
#Prescription (LicenseNum, PrescriptID,Refills,Dosage,CareCardNum,ReadyForPickUp,date_prescribed)
CREATE TABLE Prescription 
    (LicenseNum CHAR(10),
    PrescriptID CHAR(4),  
    Refills INT,  
    Dosage VARCHAR(50),
    CareCardNum CHAR(10),
    ReadyForPickUp tinyint(1),
    date_prescribed DATE,
    PRIMARY KEY (PrescriptID),
    FOREIGN KEY (LicenseNum) REFERENCES Doctor (LicenseNum) ON DELETE CASCADE,
    FOREIGN KEY (CareCardNum) REFERENCES Patient (CareCardNum) ON DELETE CASCADE);

grant select on Prescription to public;

#Drug(BrandName, GenericName, CompanyName,Price)    
CREATE TABLE Drug
    (BrandName VARCHAR(30),
    GenericName VARCHAR(30),
    CompanyName VARCHAR(30),
    Price INT,
    PRIMARY KEY (BrandName, GenericName));        

grant select on Drug to public;

#Includes(PrescriptID, BrandName, GenericName)
CREATE TABLE Includes
    (PrescriptID CHAR(4),
    BrandName VARCHAR(30),    
    GenericName VARCHAR(30),
    PRIMARY KEY (PrescriptID, BrandName, GenericName),
    FOREIGN KEY (PrescriptID) REFERENCES Prescription (PrescriptID) ON DELETE CASCADE,
    FOREIGN KEY (BrandName, GenericName) REFERENCES Drug (BrandName, GenericName) ON DELETE CASCADE);

grant select on Includes to public;

#InteractsWith(dBrandName, dGenericName, iBrandName,iGenericName)
CREATE TABLE InteractsWith
    (dBrandName VARCHAR(30),
    dGenericName VARCHAR(30),
    iBrandName VARCHAR(30),
    iGenericName VARCHAR(30),
    PRIMARY KEY (dBrandName, dGenericName, iBrandName, iGenericName),
    FOREIGN KEY (dBrandName, dGenericName) REFERENCES Drug (BrandName, GenericName),
    FOREIGN KEY (iBrandName, iGenericName) REFERENCES Drug (BrandName, GenericName));

grant select on InteractsWith to public;

#Pharmacy(Address,Name,PhoneNumber,WeekdayHoursOpening,WeekdayHoursClosing, WeekendHoursOpening,WeekendHoursClosing)
CREATE TABLE Pharmacy
    (Address VARCHAR(50),
    Name VARCHAR(40),  
    PhoneNumber CHAR(10),
    WeekdayHoursOpening TIME,
    WeekdayHoursClosing TIME,
    WeekendHoursOpening TIME,
    WeekendHoursClosing TIME,
    PRIMARY KEY (Address),
    UNIQUE (PhoneNumber));

grant select on Pharmacy to public;

#OrderedFrom(PrescriptID,PharmacyAddress, OrderNo )
CREATE TABLE OrderedFrom
    (PrescriptID CHAR(4),
    PharmacyAddress VARCHAR(50),
    OrderNo CHAR(11),
    PRIMARY KEY (PrescriptID, PharmacyAddress),
    FOREIGN KEY (PrescriptID) REFERENCES Prescription (PrescriptID) ON DELETE CASCADE,
    FOREIGN KEY (PharmacyAddress) REFERENCES Pharmacy (Address) ON DELETE CASCADE,
    UNIQUE (OrderNo));

grant select on OrderedFrom to public;

#TimeBlock(TimeBlockDate,StartTime,EndTime )
CREATE TABLE TimeBlock
    (TimeBlockDate DATE,
    StartTime TIME,
    EndTime TIME,
    PRIMARY KEY (TimeBlockDate, StartTime, EndTime));

grant select on TimeBlock to public;

#MakesAppointmentWith(TimeMade, DateMade,LicenseNum,TimeBlockDate, StartTime, EndTime, CareCardNum)
CREATE TABLE MakesAppointmentWith
    (TimeMade TIME,
    DateMade DATE,
    LicenseNum CHAR(10),
    TimeBlockDate DATE,
    StartTime TIME,
    EndTime TIME,
    CareCardNum CHAR(10),
    PRIMARY KEY (LicenseNum, TimeBlockDate, StartTime, EndTime),
    FOREIGN KEY (LicenseNum) REFERENCES Doctor (LicenseNum) ON DELETE CASCADE, 
    FOREIGN KEY (TimeBlockDate, StartTime, EndTime) REFERENCES TimeBlock (TimeBlockDate, StartTime, EndTime) ON DELETE CASCADE,
    FOREIGN KEY (CareCardNum) REFERENCES Patient (CareCardNum) ON DELETE CASCADE);

grant select on MakesAppointmentWith to public;


#Doctor(LicenseNum, FirstName, LastName,Address, PhoneNumber, Type)

INSERT INTO Doctor
VALUES ('1232131241', 'Bob', 'Smith', '1164 Robson St, Vancouver, BC V6E 1B2',
        '6049238292', 'Gynecologist');

INSERT INTO Doctor
VALUES ('5483843482', 'Alex', 'Lee', '6139 Battison St, Vancouver, BC V5S 3M7', 
        '7782313223', 'Neonatologist');

INSERT INTO Doctor
VALUES ('3422344543', 'Tau', 'Dubaku', '7547 Cambie St, Vancouver, BC V6P 3H6', 
        '6043421923', 'Obstetrician');

INSERT INTO Doctor
VALUES ('3409389847', 'Eoin', 'Raghnall', '104-350 Kent Ave South E, Vancouver, BC V5X 4N6', 
        '7783422341', 'Oncologist');


INSERT INTO Doctor
VALUES ('2743873823', 'Kaneonuskatew', 'Kawacatoose', '307-1220 Pender St E, Vancouver, BC V6A 1W8', 
        '7782391233', 'Gastroenterologist');

#Patient(CareCardNum,FirstName,LastName,Age,Weight,Height,Address,PhoneNumber )
INSERT INTO Patient
VALUES ('1234567890', 'Anny', 'Gakhokidze', '19', '90', '160', 
        '23 12746 102nd street, Surrey, BC, V3T1V9', '7783334455');

INSERT INTO Patient
VALUES ('2346528765', 'Alfred', 'Sin', '54', '90', '178', 
        '9722 Hazy Highlands, Lick, BC, V2W 9U5', '6045678765');

INSERT INTO Patient
VALUES ('1457629875', 'Jon', 'Rodness', '20', '90', '175', 
        '1413 Velvet Path, Richmond, BC, V5S 7D8', '6048790877');

INSERT INTO Patient
VALUES ('3453438890', 'Chris', 'Louie', '21', '90', '187', 
        '666 Deep Dark Road, Surrey, BC V6X 6H6', '7783921833');

INSERT INTO Patient
VALUES ('1099282394', 'Jane', 'Doe', '50', '56', '150', 
        '868 Rainbow Road, Richmond, BC V6R 2S1', '7782132349');


# prescriptions by anny
#Prescription (LicenseNum, PrescriptID,Refills,Dosage,CareCardNum,ReadyForPickUp,date_prescribed)

INSERT INTO Prescription
VALUES ('1232131241', '2345', '10', '4 pills 2 times per day for 10 days', 
       '1234567890', '1', '2015-03-21');

INSERT INTO Prescription
VALUES ('1232131241', '2959', '5', '2 pills 4 times per day for 5 days', 
       '1234567890', '1', '2012-10-26');

INSERT INTO Prescription
VALUES ('1232131241', '0001', '10', '4 pills 2 times per day for 10 days', 
       '1234567890', '1', '2012-08-22');

INSERT INTO Prescription
VALUES ('1232131241', '0002', '10', '4 pills 2 times per day for 10 days', 
       '1234567890', '1', '2012-08-23');

INSERT INTO Prescription
VALUES ('1232131241', '0003', '10', '4 pills 2 times per day for 10 days', 
       '1234567890', '1', '2012-08-24');

INSERT INTO Prescription
VALUES ('1232131241', '1111', '10', '4 pills 2 times per day for 10 days', 
       '1234567890', '1', '2012-08-24');

INSERT INTO Prescription
VALUES ('1232131241', '1112', '10', '4 pills 2 times per day for 10 days', 
       '1234567890', '1', '2012-08-24');

INSERT INTO Prescription
VALUES ('1232131241', '1113', '10', '4 pills 2 times per day for 10 days', 
       '1234567890', '1', '2012-08-24');

INSERT INTO Prescription
VALUES ('1232131241', '1114', '10', '4 pills 2 times per day for 10 days', 
       '1234567890', '1', '2012-08-24');

# INSERT INTO Prescription
# VALUES ('1232131241', '1115', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1116', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1117', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1118', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1119', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1120', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1121', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1122', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1123', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1124', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1125', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 
# INSERT INTO Prescription
# VALUES ('1232131241', '1126', '10', '4 pills 2 times per day for 10 days', 
#        '1234567890', '1', '2012-08-24');
# 


INSERT INTO Prescription
VALUES ('5483843482', '0004', '0', '1 tbsp 1 time per day for 1 day', 
       '2346528765', '0', '2014-05-10');

INSERT INTO Prescription
VALUES ('5483843482', '0005', '0', '1 tbsp 1 time per day for 1 day', 
       '2346528765', '0', '2014-05-10');

INSERT INTO Prescription
VALUES ('5483843482', '0006', '0', '1 tbsp 1 time per day for 1 day', 
       '2346528765', '0', '2014-05-10');

INSERT INTO Prescription
VALUES ('5483843482', '0007', '0', '1 tbsp 1 time per day for 1 day', 
       '2346528765', '0', '2014-05-10');

INSERT INTO Prescription
VALUES ('5483843482', '0008', '0', '1 tbsp 1 time per day for 1 day', 
       '2346528765', '0', '2014-05-10');

# ^^^ presriptions by anny

INSERT INTO Prescription
VALUES ('5483843482', '3456', '10', '1 tbsp 1 time per day for 1 day', 
       '2346528765', '1', '2014-05-10');

INSERT INTO Prescription
VALUES ('5483843482', '3457', '10', '1 tbsp 1 time per day for 1 day', 
       '2346528765', '1', '2014-05-10');

INSERT INTO Prescription
VALUES ('3422344543', '9876', '200', '12 pills 8 times per day for 45 days', 
       '1457629875', '0', '2013-12-16');

INSERT INTO Prescription
VALUES ('2743873823', '0198', '2', '1 pill 3 times per day for 10 days', 
       '3453438890', '1', '2012-12-12');

INSERT INTO Prescription
VALUES ('2743873823', '0098', '2', '1 pill 3 times per day for 10 days', 
       '3453438890', '1', '2012-12-12');

INSERT INTO Prescription
VALUES ('2743873823', '0298', '2', '1 pill 3 times per day for 10 days', 
       '3453438890', '1', '2012-12-12');

INSERT INTO Prescription
VALUES ('2743873823', '0398', '2', '1 pill 3 times per day for 10 days', 
       '3453438890', '1', '2012-12-12');

INSERT INTO Prescription
VALUES ('2743873823', '0498', '2', '1 pill 3 times per day for 10 days', 
       '3453438890', '1', '2012-12-12');

INSERT INTO Prescription
VALUES ('3409389847', '0045', '3', '1 pill 12 times per day for 3 days', 
       '1099282394', '1', '2012-12-21');


#Drug(BrandName, GenericName, CompanyName,Price)

INSERT INTO Drug 
VALUES ('Aubagio', 'Teriflunomide', 'Sanofi', '10');

INSERT INTO Drug 
VALUES ('Lovenox', 'Clopidogrel', 'Sanofi', '10');

INSERT INTO Drug 
VALUES ('Mipomereson', 'Kynamro', 'Sanofi', '10');


INSERT INTO Drug 
VALUES ('Avapro', 'irbesartan', 'Bristol-Myers Squibb', '10');


INSERT INTO Drug 
VALUES ('Tylenol', 'Acetaminophen', 'Johnson and Johnson', '10');


INSERT INTO Drug 
VALUES ('Advil', 'Ibuprofen', 'Pfizer', '11');

INSERT INTO Drug 
VALUES ('MagicDrug', 'Clindamycin', 'DatabaseDrugs Inc.', '60');

INSERT INTO Drug 
VALUES ('Ritalin', 'Methylphenidate', 'Novartis', '50');

INSERT INTO Drug 
VALUES ('Plavix', 'Clopidogrel', 'Sanofi', '20');

INSERT INTO Drug 
VALUES ('Coumadin','Warfarin','Bristol-Myers Squibb','40');

INSERT INTO Drug 
VALUES ('Zestril','Lisinopril','Apotex Inc.','50');

INSERT INTO Drug 
VALUES ('Klor-Con','Potassium Chloride','Upsher-Smith Laboratories','35');

INSERT INTO Drug 
VALUES ('Niaspan','Niacin','Abbott Laboratories','45');

INSERT INTO Drug 
VALUES ('Lipitor','Atorvastatin','Pfizer','30');

INSERT INTO Drug 
VALUES ('Viagra', 'Sildenafil','Pfizer','40');

INSERT INTO Drug 
VALUES ('Biaxin','Clarithromycin','Abbott Laboratories','50');

INSERT INTO Drug 
VALUES ('Zocor', 'Simvastatin','Pfizer','99');

#InteractsWith(dBrandName, dGenericName, iBrandName,iGenericName)

INSERT INTO InteractsWith
VALUES ('Advil', 'Ibuprofen', 'Coumadin', 'Warfarin');

INSERT INTO InteractsWith
VALUES ('Zocor', 'Simvastatin', 'Coumadin', 'Warfarin');

INSERT INTO InteractsWith
VALUES ('Klor-Con','Potassium Chloride', 'Zestril','Lisinopril');

INSERT INTO InteractsWith
VALUES ('Niaspan','Niacin','Lipitor','Atorvastatin');

INSERT INTO InteractsWith
VALUES ('Viagra', 'Sildenafil','Biaxin','Clarithromycin');

#Includes(PrescriptID, BrandName, GenericName)



INSERT INTO Includes
VALUES('1111', 'Aubagio', 'Teriflunomide');


INSERT INTO Includes
VALUES('1112', 'Lovenox', 'Clopidogrel');


INSERT INTO Includes
VALUES('1113', 'Mipomereson', 'Kynamro');


INSERT INTO Includes
VALUES('1114', 'Avapro', 'irbesartan');

INSERT INTO Includes
VALUES ('3457', 'Lovenox', 'Clopidogrel');





INSERT INTO Includes
VALUES('2345', 'Tylenol','Acetaminophen');

INSERT INTO Includes
VALUES ('3456', 'Advil','Ibuprofen');


INSERT INTO Includes
VALUES ('9876', 'Ritalin', 'Methylphenidate');

INSERT INTO Includes
VALUES ('0098', 'Plavix', 'Clopidogrel');

INSERT INTO Includes
VALUES ('0198', 'Lipitor','Atorvastatin');

INSERT INTO Includes
VALUES ('0298', 'Zocor', 'Simvastatin');

INSERT INTO Includes
VALUES ('0398', 'Viagra', 'Sildenafil');

# INSERT INTO Includes
# VALUES ('0498', 'Advil', 'Ibuprofen');

INSERT INTO Includes
VALUES ('0045', 'Coumadin','Warfarin');

INSERT INTO Includes
VALUES ('0001', 'Advil','Ibuprofen');

INSERT INTO Includes
VALUES ('0002', 'Coumadin','Warfarin');

INSERT INTO Includes
VALUES ('0003', 'Coumadin','Warfarin');

INSERT INTO Includes
VALUES ('0004', 'Advil','Ibuprofen');

INSERT INTO Includes
VALUES ('0005', 'Lipitor','Atorvastatin');

INSERT INTO Includes
VALUES ('0006', 'Zocor','Simvastatin');

INSERT INTO Includes
VALUES ('0007', 'Viagra','Sildenafil');

#Pharmacy(Address,Name,PhoneNumber,WeekdayHoursOpening,WeekdayHoursClosing, WeekendHoursOpening,WeekendHoursClosing)

INSERT INTO Pharmacy
VALUES ('885 Broadway W, Vancouver, BC V5Z 1J9','Shoppers Drug Mart', '6047081135', 
        '08:00:00' , '22:00:00', '10:00:00','18:00:00');

INSERT INTO Pharmacy
VALUES ('3303 Main St, Vancouver, BC V5V 3M8', 'Shoppers Drug Mart', '7783289580', 
        '8:30:00','22:00:00', '10:30:00','18:00:00');

INSERT INTO Pharmacy
VALUES ('4255 Arbutus St, Vancouver, BC V6J 4R1', 'Safeway Pharmacy',  '6047316252',
       '8:30:00','22:00:00','8:30:00','22:00:00');

INSERT INTO Pharmacy
VALUES ('102-888 8th Ave W, Vancouver, BC V5Z 3Y1',  'Costco Wholesale Pharmacy', '7782313849',
         '09:00:00', '20:00:00', '10:00:00','18:00:00');

INSERT INTO Pharmacy
VALUES ('6180 Fraser St, Vancouver, BC V5W 3A1', 'The Medicine Shoppe Pharmacy', '6042333233',
        '08:00:00','22:30:00','11:00:00','18:00:00');


#OrderedFrom(PrescriptID,PharmacyAddress, OrderNo )
INSERT INTO OrderedFrom
VALUES ('2345', '885 Broadway W, Vancouver, BC V5Z 1J9', '03457436534');

INSERT INTO OrderedFrom
VALUES ('3456', '3303 Main St, Vancouver, BC V5V 3M8', '54362785237');

INSERT INTO OrderedFrom
VALUES ('9876', '4255 Arbutus St, Vancouver, BC V6J 4R1', '41327584378');

INSERT INTO OrderedFrom
VALUES ('0098', '102-888 8th Ave W, Vancouver, BC V5Z 3Y1', '64389564389');

# ordered by anny
INSERT INTO OrderedFrom
VALUES ('0001', '6180 Fraser St, Vancouver, BC V5W 3A1', '41327584379');

INSERT INTO OrderedFrom
VALUES ('0002', '6180 Fraser St, Vancouver, BC V5W 3A1', '41327584321');

INSERT INTO OrderedFrom
VALUES ('0003', '6180 Fraser St, Vancouver, BC V5W 3A1', '41327584123');

# ^^^ ordered by anny

#TimeBlock(TimeBlockDate,StartTime,EndTime )
INSERT INTO TimeBlock
VALUES ('2015-04-03', '11:30:00', '12:00:00');

INSERT INTO TimeBlock
VALUES ('2015-04-03', '09:00:00', '10:00:00');

INSERT INTO TimeBlock
VALUES ('2015-04-03', '10:30:00', '11:00:00');




INSERT INTO TimeBlock
VALUES ('2874-06-07', '09:00:00', '12:00:00');

INSERT INTO TimeBlock
VALUES ('2015-07-14', '13:00:00', '15:00:00');

INSERT INTO TimeBlock
VALUES ('2015-10-24', '15:00:00', '16:00:00');

INSERT INTO TimeBlock
VALUES ('2015-07-04', '16:00:00', '16:30:00');

INSERT INTO TimeBlock
VALUES ('2014-07-04', '16:00:00', '16:30:00');

INSERT INTO TimeBlock
VALUES ('2013-07-04', '16:00:00', '16:30:00');

#MakesAppointmentWith(TimeMade, DateMade,LicenseNum,TimeBlockDate, StartTime, EndTime, CareCardNum)
INSERT INTO MakesAppointmentWith
VALUES ('09:0:00', '2015-04-01','1232131241','2015-04-03','11:30:00','12:00:00','1234567890');
INSERT INTO MakesAppointmentWith
VALUES ('09:00:00', '2015-04-03','1232131241','2015-04-03','09:00:00','10:00:00','1234567890');

INSERT INTO MakesAppointmentWith
VALUES ('9:30:00', '2015-04-02','1232131241','2015-04-03','10:30:00','11:00:00','1234567890');



INSERT INTO MakesAppointmentWith
VALUES ('10:00:00', '2874-06-08', '5483843482', '2874-06-07', '09:00:00', '12:00:00', '2346528765');

INSERT INTO MakesAppointmentWith
VALUES ('11:30:00', '2015-07-14' , '3422344543', '2015-07-14', '13:00:00', '15:00:00', '1457629875');

INSERT INTO MakesAppointmentWith
VALUES('14:30:00', '2015-10-24', '3409389847', '2015-10-24', '15:00:00', '16:00:00', '3453438890');

INSERT INTO MakesAppointmentWith
VALUES('08:30:00', '2015-07-04', '2743873823', '2015-07-04', '16:00:00', '16:30:00', '1099282394');

INSERT INTO MakesAppointmentWith
VALUES('08:30:00', '2013-07-04', '2743873823', '2014-07-04', '16:00:00', '16:30:00', '1234567890');

INSERT INTO MakesAppointmentWith
VALUES('10:30:00', '2012-08-04', '2743873823', '2013-07-04', '16:00:00', '16:30:00', '1234567890');



