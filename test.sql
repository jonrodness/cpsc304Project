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
