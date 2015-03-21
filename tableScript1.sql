create database doctors;
    use doctors;

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

#bit 0 false, 1 true
CREATE TABLE Prescription 
    (LicenseNum CHAR(10),
    PrescriptID CHAR(10),  
    Refills INT,  
    Dosage VARCHAR(50),
    CareCardNum CHAR(10),
    ReadyForPickUp bit,
    date_prescribed DATE,
    PRIMARY KEY (PrescriptID),
    FOREIGN KEY (LicenseNum) REFERENCES Doctor (LicenseNum),
    FOREIGN KEY (CareCardNum) REFERENCES Patient (CareCardNum) ON DELETE CASCADE,
    Check (Refills >= 0));

grant select on Prescription to public;

CREATE TABLE Drug
    (BrandName VARCHAR(30),
    GenericName VARCHAR(30),
    CompanyName VARCHAR(30),
    Price INT,
    PRIMARY KEY (GenericName, CompanyName),
    UNIQUE (BrandName));        

grant select on Drug to public;

CREATE TABLE Includes
    (PrescriptID CHAR(4),
    GenericName VARCHAR(30),
    CompanyName VARCHAR(30),
    PRIMARY KEY (PrescriptID, GenericName, CompanyName),
    FOREIGN KEY (PrescriptID) REFERENCES Prescription (PrescriptID),
    FOREIGN KEY (GenericName, CompanyName) REFERENCES Drug (GenericName, CompanyName));

grant select on Includes to public;

CREATE TABLE InteractsWith
    (dGenericName VARCHAR(30),
    dCompanyName VARCHAR(30),
    iGenericName VARCHAR(30),
    iCompanyName VARCHAR(30),
    PRIMARY KEY (dGenericName, dCompanyName, iGenericName, iCompanyName),
    FOREIGN KEY (iGenericName, iCompanyName) REFERENCES Drug (GenericName, CompanyName) ON DELETE CASCADE);

grant select on InteractsWith to public;

CREATE TABLE Pharmacy
    (Address VARCHAR(50),
    PhoneNumber CHAR(10),
    Name VARCHAR(20),   
    WeekdayHoursOpening TIME,
    WeekdayHoursClosing TIME,
    WeekendHoursOpening TIME,
    WeekendHoursClosing TIME,
    PRIMARY KEY (Address),
    UNIQUE (PhoneNumber));

grant select on Pharmacy to public;

CREATE TABLE OrderedFrom
    (PrescriptID CHAR(4),
    PharmacyAddress VARCHAR(50),
    OrderNo CHAR(11),
    PRIMARY KEY (PrescriptID, PharmacyAddress),
    FOREIGN KEY (PrescriptID) REFERENCES Prescription (PrescriptID) ON DELETE CASCADE,
    FOREIGN KEY (PharmacyAddress) REFERENCES Pharmacy (Address) ON DELETE CASCADE,
    UNIQUE (OrderNo));

grant select on OrderedFrom to public;

CREATE TABLE TimeBlock
    (TimeBlockDate DATE,
    StartTime TIME,
    EndTime TIME,
    PRIMARY KEY (TimeBlockDate, StartTime, EndTime));

grant select on TimeBlock to public;

CREATE TABLE MakesAppointmentWith
    (TimeMade TIME,
    DateMade DATE,
    LicenseNum CHAR(10),
    TimeBlockDate DATE,
    StartTime TIME,
    EndTime TIME,
    CareCardNum CHAR(10),
    PRIMARY KEY (LicenseNum, TimeBlockDate, StartTime, EndTime),
    FOREIGN KEY (LicenseNum) REFERENCES Doctor (LicenseNum),
    FOREIGN KEY (TimeBlockDate, StartTime, EndTime) REFERENCES TimeBlock (TimeBlockDate, StartTime, EndTime),
    FOREIGN KEY (CareCardNum) REFERENCES Patient (CareCardNum));

grant select on MakesAppointmentWith to public;

# ---------------- INSERTION ---------------- #

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

INSERT INTO Prescription

VALUES ('1232131241', '2345', '10', '4 pills 2 times per day for 10 days', 
       '1234567890', '1', '2012-08-26');

INSERT INTO Prescription
VALUES ('5483843482', '3456', '0', '1 tbsp 1 time per day for 1 day', 
       '2346528765', '0', '2014-05-10');

INSERT INTO Prescription
VALUES ('3422344543', '9876', '200', '12 pills 8 times per day for 45 days', 
       '1457629875', '0', '2013-12-16');

INSERT INTO Prescription
VALUES ('2743873823', '0098', '2', '1 pill 3 times per day for 10 days', 
       '3453438890', '1', '2012-12-12');

INSERT INTO Prescription
VALUES ('3409389847', '0045', '3', '1 pill 12 times per day for 3 days', 
       '1099282394', '1', '2012-12-21');

INSERT INTO Drug 
VALUES ('Tylenol', 'Acetaminophen', 'Johnson and Johnson', '10');

INSERT INTO Drug 
VALUES ('Advil', 'Ibuprofen', 'Pfizer', '11');

INSERT INTO Drug 
VALUES ('null', 'Clindamycin', 'DatabaseDrugs Inc.', '60');

INSERT INTO Drug 
VALUES ('Ritalin', 'Methylphenidate', 'Novartis', '50');

INSERT INTO Drug 
VALUES ('Plavix', 'Clopidogrel', 'Sanofi', '20');


INSERT INTO Includes
VALUES('2345', 'Acetaminophen', 'Johnson and Johnson');

INSERT INTO Includes
VALUES ('3456', 'Ibuprofen', 'Pfizer');

INSERT INTO Includes
VALUES ('9876', 'Clindamycin', 'DatabaseDrugs Inc.');

INSERT INTO Includes
VALUES ('0098', 'Methylphenidate', 'Novartis');

INSERT INTO Includes
VALUES ('0045', 'Clopidogrel', 'Sanofi');

# INSERT INTO Includes
# VALUES ('9876', 'Dextromethorphan', 'Robitussin')
# 
# INSERT INTO Includes
# VALUES ('0098', 'Paroxetine', 'Paxil')
# 
# INSERT INTO Includes
# VALUES('0045', 'Escatalopram', 'Lexapro');



INSERT INTO InteractsWith
VALUES ('Ibuprofen', 'Advil', 'Coumadin', 'Warfarin');

INSERT INTO InteractsWith
VALUES ('Simvastatin', 'Zocor', 'Coumadin', 'Warfarin');

INSERT INTO InteractsWith
VALUES ('Klor-Con', 'Potassium Chloride', 'Lisinopril', 'Zestril');

INSERT INTO InteractsWith
VALUES ('Nicotinic Acid', 'Niacin', 'Atorvastatin', 'Lipitor');

INSERT INTO InteractsWith
VALUES ('Sildenafil', 'Viagra', 'Clarithromycin', 'Biaxin');

#Pharmacy(Address, PhoneNumber, Name, WeekdayHoursOpening, .. , .. , .. )

   
INSERT INTO Pharmacy
VALUES ('885 Broadway W, Vancouver, BC V5Z 1J9', '6047081135', 'Shoppers Drug Mart', 
        '08:00:00' , '22:00:00', '10:00:00','18:00:00');

INSERT INTO Pharmacy
VALUES ('3303 Main St, Vancouver, BC V5V 3M8', '7783289580', 'Shoppers Drug Mart', 
        '8:30:00','22:00:00', '10:30:00','18:00:00');

INSERT INTO Pharmacy
VALUES ('4255 Arbutus St, Vancouver, BC V6J 4R1', 'Safeway Pharmacy', '6047316252', 
       '8:30:00','22:00:00','8:30:00','22:00:00');

INSERT INTO Pharmacy
VALUES ('102-888 8th Ave W, Vancouver, BC V5Z 3Y1', 'Costco Wholesale Pharmacy', 
        '7782313849', '09:00:00', '20:00:00', '10:00:00','18:00:00');

INSERT INTO Pharmacy
VALUES ('6180 Fraser St, Vancouver, BC V5W 3A1', 'The Medicine Shoppe Pharmacy', 
        '6042333233','08:00:00','22:30:00','11:00:00','18:00:00');

INSERT INTO OrderedFrom
VALUES ('2345', '885 Broadway W, Vancouver, BC V5Z 1J9', '03457436534');

INSERT INTO OrderedFrom
VALUES ('3456', '3303 Main St, Vancouver, BC V5V 3M8', '54362785237');

INSERT INTO OrderedFrom
VALUES ('9876', '4255 Arbutus St, Vancouver, BC V6J 4R1', '41327584378');

INSERT INTO OrderedFrom
VALUES ('0098', '102-888 8th Ave W, Vancouver, BC V5Z 3Y1', '64389564389');

INSERT INTO OrderedFrom
VALUES ('0045', '6180 Fraser St, Vancouver, BC V5W 3A1', '42385728055');

INSERT INTO TimeBlock
VALUES ('2015-04-03', '09:00:00', '10:00:00');

INSERT INTO TimeBlock
VALUES ('2874-06-07', '09:00:00', '12:00:00');

INSERT INTO TimeBlock
VALUES ('2015-07-14', '13:00:00', '15:00:00');

INSERT INTO TimeBlock
VALUES ('2015-10-24', '15:00:00', '16:00:00');

INSERT INTO TimeBlock
VALUES ('2015-07-04', '16:00:00', '16:30:00');

INSERT INTO MakesAppointmentWith
VALUES ('09:00:00', '2015-04-03','1232131241','2015-04-03','09:00:00','10:00:00','1234567890');

INSERT INTO MakesAppointmentWith
VALUES ('10:00:00', '2874-06-08', '5483843482', '2874-06-07', '09:00:00', '12:00:00', '2346528765');

INSERT INTO MakesAppointmentWith
VALUES ('11:30:00', '2015-07-14' , '3422344543', '2015-07-14', '13:00:00', '15:00:00', '1457629875');

INSERT INTO MakesAppointmentWith
VALUES('14:30:00', '2015-10-24', '3409389847', '2015-10-24', '15:00:00', '16:00:00', '3453438890');

INSERT INTO MakesAppointmentWith
VALUES('08:30:00', '2015-07-04', '2743873823', '2015-07-04', '16:00:00', '16:30:00', '1099282394');


    


