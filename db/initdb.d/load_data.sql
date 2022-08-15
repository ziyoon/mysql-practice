-- Load data

-- USE practice;

-- Load Customer.csv file : './db/initdb.d/Customer.csv' 
LOAD DATA INFILE '/data/Customer.csv'
INTO TABLE customer 
FIELDS TERMINATED BY ',' ENCLOSED BY ''''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Load Sales.csv file : './db/initdb.d/Sales.csv'
LOAD DATA INFILE '/data/Sales.csv' 
INTO TABLE sales
FIELDS TERMINATED BY ',' ENCLOSED BY ''''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Load Productl.csv file :  './db/initdb.d/Product.csv'
LOAD DATA INFILE '/data/Product.csv' 
INTO TABLE product
FIELDS TERMINATED BY ',' ENCLOSED BY ''''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;