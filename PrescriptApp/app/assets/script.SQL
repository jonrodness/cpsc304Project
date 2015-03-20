CREATE TABLE Drug (brand_name CHAR(30),
          generic_name CHAR(30),
          company_name CHAR(30),
          price INT,
          PRIMARY KEY (generic_name, company_name),
          UNIQUE (brand_name));


INSERT 
INTO Drug(brand_name, generic_name, company_name, price)
VALUE ('Tylenol', 'Acetaminophen', 'Johnson & Johnson', 10);

INSERT 
INTO Drug(brand_name, generic_name, company_name, price)
VALUE ('Advil', 'Ibuprofen', 'Some Company', 10);

