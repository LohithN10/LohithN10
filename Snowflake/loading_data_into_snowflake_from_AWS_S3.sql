create warehouse PWH;
Create or replace database  EXERCISE_DB;
create or replace schema exercise_db.new_schema;

use schema exercise_db.new_schema;

Create table CUSTOMERS (
id int,
first_name varchar,
last_name varchar,
email varchar,
age int,
city varchar);

copy into customers from s3://snowflake-assignments-mc/gettingstarted/customers.csv
file_format = (
                type = csv
                field_delimiter = ','
                skip_header = 1 );

select count(*) from customers;
    

-- Course solution
 -- Create database 
 create or replace database EXERCISE_DB; 
 
-- Create table 
 create or replace table EXERCISE_DB.NEW_SCHEMA.CUSTOMERS ( 
     id int, 
     first_name varchar, 
     last_name varchar, 
     email varchar, 
     age int,
     city varchar);
     

-- Load data 
copy into customers   
from s3://snowflake-assignments-mc/gettingstarted/customers.csv   file_format = (     type = csv      field_delimiter = ','      skip_header = 1);   

-- Query from table
SELECT * FROM customers;  


-- Creating a warehouse

USE ROLE SYSADMIN;

CREATE WAREHOUSE PRACTICE_WH
WAREHOUSE_SIZE = XSMALL
AUTO_SUSPEND = 300  -- this will automatically suspend the virtual warehouse after 300 seconds of not being used
AUTO_RESUME = TRUE 
COMMENT = 'This is a virtual warehouse of size X-SMALL that can be used to process general simple queries.';

DROP WAREHOUSE PRACTICE_WH;