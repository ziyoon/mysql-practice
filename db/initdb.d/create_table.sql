--  CREATE TABLES

-- USE practice;

-- customer TABLE : mem_no, gender, birthday, addr, join_date
CREATE TABLE customer (
    mem_no      INT,
    gender      VARCHAR(20),
    birthday    DATE,
    addr        CHAR(25),
    join_date   DATE,
    PRIMARY KEY (mem_no)
);

-- sales TABLE : order_no, mem_no, order_date, product_code, sales_qty
CREATE TABLE sales (
    order_no        INT,
    mem_no          INT,
    order_date      DATE,
    product_code    INT,
    sales_qty       INT,
    PRIMARY KEY (order_no)
);

-- product TABLE : product_code, category, type, brand, product_name, price
CREATE TABLE product(
    product_code    INT,
    category        VARCHAR(20),
    type            VARCHAR(20),
    brand           VARCHAR(20),
    product_name    VARCHAR(100),
    price           INT,
    PRIMARY KEY (product_code)
);