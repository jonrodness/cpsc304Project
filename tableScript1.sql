drop database doctors;
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




