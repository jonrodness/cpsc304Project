
drop table Doctor;
drop table Patient;
drop table Prescription;
drop table Includes;
drop table Drug;
drop table InteractsWith;
drop table Pharmacy;
drop table OrderedFrom;
drop table TimeBlock;
drop table MakesAppointmentWith;

# ---------------- CREATION ---------------- #

CREATE TABLE Doctor 
    (LicenseNum INT,
    FirstName CHAR (20),
    LastName CHAR (20),
    Address CHAR (50),
    PhoneNumber INT,
    Type CHAR (20),
    PRIMARY KEY (LicenseNum),
    UNIQUE 	(Address, FirstName, LastName));

grant select on Doctor to public;

CREATE TABLE Patient
    (CareCardNum CHAR(10),
    FirstName CHAR (20),    
    LastName CHAR (20), 
    Age INT,
    Weight INT,
    Height INT,
    Address CHAR (50),
    PhoneNumber CHAR(9), 
    PRIMARY KEY (CareCardNum)
    UNIQUE KEY (Address, First Name, Last Name));

grant select on Patient to public;               

CREATE TABLE Prescription 
    (LicenseNum CHAR(20) NOT NULL,
    PrescriptID INT,  
    Refills INT,  
    Dosage CHAR(50),
    CareCardNum CHAR (10) NOT NULL,
   	ReadyForPickUp BOOLEAN,
	date CHAR (20),
    PRIMARY KEY (PrescriptID)
    FOREIGN KEY (LicenseNum) REFERENCES Doctor,
    FOREIGN KEY (CareCardNum) REFERENCES Patient ON DELETE CASCADE)
    Check Refills >=0;

grant select on Prescription to public;

CREATE TABLE Includes
    (PrescriptID INT,
    GenericName CHAR(30),
    CompanyName CHAR(30),
    PRIMARY KEY (PrescriptID, GenericName, CompanyName),
    FOREIGN KEY (PrescriptID) REFERENCES Prescription,
	FOREIGN KEY (GenericName, CompanyName) REFERENCES Drug));

grant select on Includes to public;
          
CREATE TABLE Drug
    (BrandName CHAR(30),
    GenericName CHAR(30),
    CompanyName CHAR(30),
    Price INT,
    PRIMARY KEY (GenericName, CompanyName),
    UNIQUE (BrandName));		

grant select on Drug to public;

CREATE TABLE InteractsWith
    (dGenericName CHAR(30),
    dCompanyName CHAR(30),
    iGenericName CHAR(30),
    iCompanyName CHAR(30),
    PRIMARY KEY (dGenericName, dCompanyName, iGenericName, iCompanyName),
	FOREIGN KEY (iGenericName) REFERENCES Drug.GenericName ON DELETE CASCADE,
	FOREIGN KEY (iCompanyName) REFERENCES Drug.CompanyName ON DELETE CASCADE);

grant select on InteractsWith to public;

CREATE TABLE Pharmacy
    (Address CHAR (50),
    PhoneNumber CHAR(9),
    Name CHAR(20),   
    WeekdayHours CHAR (11),
    WeekendHours CHAR (11),
    PRIMARY KEY (Address),
    UNIQUE PhoneNumber));

grant select on Pharmacy to public;

CREATE TABLE OrderedFrom
    (PrescriptID INT,
	PharmacyAddress CHAR (50),
	OrderNo INT,
	PRIMARY KEY (PrescriptID, PharmacyAddress),
	FOREIGN KEY (PrescriptID) REFERENCES Prescription ON DELETE CASCADE,
	FOREIGN KEY (PharmacyAddress) REFERENCES Pharmacy ON DELETE CASCADE,
	UNIQUE (OrderNo));

grant select on OrderedFrom to public;

CREATE TABLE TimeBlock
    (Date CHAR (20),
	StartTime INT,
    EndTime INT,
    PRIMARY KEY (Date, StartTime, EndTime));

grant select on TimeBlock to public;

CREATE TABLE MakesAppointmentWith
    (TimeMade CHAR (20),
	DateMade CHAR (20),
    LicenseNum CHAR (20),
	Date CHAR (20),
	StartTime INT,
	EndTime INT,
	CareCardNumber CHAR(10) NOT NULL,
	PRIMARY KEY (LicenseNum, Date, StartTime, EndTime),
	FOREIGN KEY (LicenseNum) REFERENCES Doctor,
	FOREIGN KEY (Date, StartTime, EndTime) REFERENCES Timeblock,
	FOREIGN KEY (CareCardNum) REFERENCES Patient);

grant select on MakesAppointmentWith to public;


# ---------------- INSERTION ---------------- #
INSERT INTO Doctor
VALUES ('123 213 1241', 'Bob', 'Smith', '1164 Robson St, Vancouver, BC V6E 1B2',
        '604 923 8292', 'Gynecologist');

INSERT INTO Doctor
VALUES ('548 384 3482', 'Alex', 'Lee', '6139 Battison St, Vancouver, BC V5S 3M7', 
        '778 231 3223', 'Neonatologist');

INSERT INTO Doctor
VALUES ('342 234 4543', 'Tau', 'Dubaku', '7547 Cambie St, Vancouver, BC V6P 3H6', 
        '604 342 1923', 'Obstetrician');

INSERT INTO Doctor
VALUES ('340 938 9847', 'Eoin', 'Raghnall', '104-350 Kent Ave South E, Vancouver, BC V5X 4N6', 
        '778 342 2341', 'Oncologist');


INSERT INTO Doctor
VALUES ('274 387 3823', 'Kaneonuskatew', 'Kawacatoose', '307-1220 Pender St E, Vancouver, BC V6A 1W8', 
        '778 239 1233', 'Gastroenterologist');

INSERT INTO Patient
VALUES ('123 456 7890', 'Anny', 'Gakhokidze', '19', '90', '160', 
        '23 12746 102nd street, Surrey, BC, V3T1V9', '778 333 44 55');

INSERT INTO Patient
VALUES ('234 652 8765', 'Alfred', 'Sin', '54', '90', '178', 
        '9722 Hazy Highlands, Lick, BC, V2W 9U5', '604 567 87 65');

INSERT INTO Patient
VALUES ('145 762 9875', 'Jon', 'Rodness', '20', '90', '175', 
        '1413 Velvet Path, Richmond, BC, V5S 7D8', '604 879 08 77');

INSERT INTO Patient
VALUES ('345 343 8890', 'Chris', 'Louie', '21', '90', '187', 
        '666 Deep Dark Road, Surrey, BC V6X 6H6', '778 392 1833');

INSERT INTO Patient
VALUES ('109 928 2394', 'Jane', 'Doe', '50', '56', '150', 
        '868 Rainbow Road, Richmond, BC V6R 2S1', '778 213 2349');

INSERT INTO Prescription
VALUES ('1234567890', '2345', '10', '4 pills 2 times per day for 10 days', 
       '1234 456 789', 'TRUE', '26/08/2012');

INSERT INTO Prescription
VALUES ('2345678901', '3456', '0', '1 tbsp 1 time per day for 1 day', 
       '2345 456 789', 'FALSE', '05/10/2014');

INSERT INTO Prescription
VALUES ('1098233744', '9876', '200', '12 pills 8 times per day for 45 days', 
       '0987 123 576', 'FALSE', '16/12/2013');

INSERT INTO Prescription
VALUES ('2034765764', '0098', '2', '1 pill 3 times per day for 10 days', 
       '1987 473 123', 'TRUE', '12/12/2012');

INSERT INTO Prescription
VALUES ('0921837515', '0045', '3', '1 pill 12 times per day for 3 days', 
       '0982 173 333', 'TRUE', '12/21/2012');

INSERT INTO Includes
VALUES('2345', 'Acetaminophen', 'Johnson and Johnson');

INSERT INTO Includes
VALUES ('3456', 'Ibuprofen', 'Pfizer');

INSERT INTO Includes
VALUES ('9876', 'Dextromethorphan', 'Robitussin');

INSERT INTO Includes
VALUES ('0098', 'Paroxetine', 'Paxil');


INSERT INTO Includes
VALUES('0045', 'Escatalopram', 'Lexapro');

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

INSERT INTO Pharmacy
VALUES ('885 Broadway W, Vancouver, BC V5Z 1J9', '604-708-1135', 'Shoppers Drug Mart', 
        '10:00-18:00', '8:00-22:00', '8:00-22:00', '8:00-22:00', '8:00-22:00', '8:00-22:00', '10:00-18:00');

INSERT INTO Pharmacy
VALUES ('3303 Main St, Vancouver, BC V5V 3M8', '778-328-9580', 'Shoppers Drug Mart', 
        '10:00-19:00', '8:30-22:00', '8:30-22:00', '8:30-22:00', '8:30-22:00', '8:30-22:00', '10:30-18:00');

INSERT INTO Pharmacy
VALUES ('4255 Arbutus St, Vancouver, BC V6J 4R1', 'Safeway Pharmacy', '604 731 6252', 
        '8:30-22:00', '8:30-22:00', '8:30-22:00', '8:30-22:00','8:30-22:00', '8:30-22:00', '8:30-22:00');

INSERT INTO Pharmacy
VALUES ('102-888 8th Ave W, Vancouver, BC V5Z 3Y1', 'Costco Wholesale Pharmacy', 
        '778 231 3849', '9:00-21:00', '7:00-21:00', '7:00-21:00', '7:00-21:00', '7:00-21:00', 
        '7:00-21:00', '9:00-21:00');

INSERT INTO Pharmacy
VALUES ('6180 Fraser St, Vancouver, BC V5W 3A1', 'The Medicine Shoppe Pharmacy', 
        '604 233 3233','11:30-18:00', '8:00-22:30','8:00-22:30', '8:00-22:30', '8:00-22:30', 
        '8:00-22:30', '11:30-18:00');

INSERT INTO OrderedFrom
VALUES ('2345', '885 Broadway W, Vancouver, BC V5Z 1J9', '03457436534');

INSERT INTO OrderedFrom
VALUES ('3467', '3303 Main St, Vancouver, BC V5V 3M8', '54362785237');

INSERT INTO OrderedFrom
VALUES ('5633', '4255 Arbutus St, Vancouver, BC V6J 4R1', '41327584378');

INSERT INTO OrderedFrom
VALUES ('5678', '102-888 8th Ave W, Vancouver, BC V5Z 3Y1', '64389564389');

INSERT INTO OrderedFrom
VALUES ('6345', '6180 Fraser St, Vancouver, BC V5W 3A1', '42385728055');

INSERT INTO TimeBlock
VALUES ('04/03/2015', '09:00', '10:00');

INSERT INTO TimeBlock
VALUES ('06/07/2874', '09:00', '12:00');

INSERT INTO TimeBlock
VALUES ('07/14/2015', '13:00', '15:00');

INSERT INTO TimeBlock
VALUES ('10/24/2015', '15:00', '16:00');

INSERT INTO TimeBlock
VALUES ('07/04/2015', '16:00', '16:30');

INSERT INTO MakesAppointment_with
VALUES ('09:00', '04/03/2015','123 213 1241','04/03/2015','09:00','10:00','123 456 7890');

INSERT INTO MakesAppointment_with
VALUES ('10:00', '06/08/2874', '548 384 3482', '06/07/2874', '09:00', '12:00', '234 652 8765');

INSERT INTO MakesAppointment_with
VALUES ('11:30', '07/14/2015' , '342 234 4543', '07/14/2015', '13:00', '15:00', '145 762 9875');

INSERT INTO MakesAppointment_with
VALUES('14:30', '10/24/2015', '340 938 9847', '10/24/2015', '15:00', '16:00', '345 343 8890');

INSERT INTO MakesAppointment_with
VALUES('8:30', '07/04/2015', '274 387 3823', '07/04/2015', '16:00', '16:30', '109 928 2394');
