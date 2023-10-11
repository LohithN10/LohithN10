create or replace schema exercise_db.file_format;

create or replace file format exercise_db.file_format.my_file_format;

desc file format my_file_format;

create or replace table EXERCISE_DB.NEW_SCHEMA.CUSTOMERS ( 
     id int, 
     first_name varchar, 
     last_name varchar, 
     email varchar, 
     age int,
     city varchar);
          
copy into new_schema.customers from s3://snowflake-assignments-mc/loadingdata
file_format = (format_name = file_format.my_file_format );

copy into db.s.t (c1,c2)
from (select s.c1, s.c2 fom @db.s.stage s)  // s.$1,s.$2 selects first and second column
file_format = (file_format = file_format.my_file_format)
files = ('filename.csv') or
pattern =".*string_match*.";

alter file format my_file_format
set skip_header =1;

alter file format my_file_format
set field_delimiter =';';


//We cannot update the type of a file format cause different tyeps will have 
-- different file format properties so, if we need a different type we have specify at the time of 
-- creation it self.  Ex:

create or replace file format exercise_db.file_format.my_file_format_json
    type = JSON,
    time_format =AUTO;

//If we need any one or more properties to be different than file format we can use the below syntax


drop table new_schema.customers;


copy into new_schema.customers from s3://snowflake-assignments-mc/loadingdata
file_format = (format_name = file_format.my_file_format field_delimiter = ',' skip_header=1 )
validation_mode = return_errors;
//Learn details of stage object and file format object

// If you would like to continue loading when an error is encountered, use other values such as
--  SKIP_FILE or CONTINUE for the ON_ERROR option. For more information on loading options, please run 
-- info loading_data in a SQL client.

create or replace stage STAGE_DB.EXTERNAL_STAGES.s3_stage
    url =' s3://snowflake-assignments-mc/fileformat/';

list @STAGE_DB.EXTERNAL_STAGES.s3_stage;

create or replace file format exercise_db.file_format.my_file_format
    field_delimiter = '|',
    skip_header = 1;

copy into EXERCISE_DB.NEW_SCHEMA.CUSTOMERS 
from @STAGE_DB.EXTERNAL_STAGES.s3_stage
file_format = (format_name=exercise_db.file_format.my_file_format)
ON_ERROR = 'CONTINUE'; 
ON_ERROR = 'SKIP_FILE_3'; -- WITH LIMIT CAN BE PERCENTAGE TOO
VALIDATION_MODE = RETURN_10_ROWS | RETURN_ERRORS 
--OR SKIP_FILE
OR -- BY DEFUALT THIS WILL BE EXECUTED

ON_ERROR = 'ABORT_STATEMENT'

select count(*) from EXERCISE_DB.NEW_SCHEMA.CUSTOMERS ;

-- getting the rejected records or error records into a table

create or replace table rejected as
select REJECTED_RECORD from table(result_scan(last_query_id()));

// On giving continue in on_error property we can use the following code to get the rejected records

select * from table(validate(orders,job_id => '_last')) 

// creating tables for rejected values.

CREATE or replace table rejected_values as
select 
    split_part(rejected_record,',',1) as C1,
    split_part(rejected_record,',',2) as C2,
    ..
    split_part(rejected_record,',',n) as Cn 
    from rejected;

//COPY OPTION - SIZE LIMIT
-- maximum size and it will be in bytes of data that will be loaded
-- the first file will be loaded either way. Then only after the limit has been exceeded with the last file, 
-- no more additional file will be loaded, anti-copy operation stops completely afterwards.     

copy into EXERCISE_DB.NEW_SCHEMA.CUSTOMERS 
from @STAGE_DB.EXTERNAL_STAGES.s3_stage
file_format = (format_name=exercise_db.file_format.my_file_format)
ON_ERROR = 'CONTINUE'
SIZE_LIMIT = 5
FORCE = TRUE ; //BY DEFAULT IT IS FALSE, THIS LAODS DATA ANYWAYS CREATES DUPLICATES IF THE DATA WAS LOADED EARLIER

CREATE OR REPLACE TABLE EXERCISE_DB.NEW_SCHEMA.EMPLOYEES
(   customer_id int,
    first_name varchar(50),
  last_name varchar(50),
  email varchar(50),
  age int,
  department varchar(50)
);

CREATE STAGE STAGE_DB.EXTERNAL_STAGES.STAGE3
URL='s3://snowflake-assignments-mc/copyoptions/example1';

LIST @STAGE_DB.EXTERNAL_STAGES.STAGE3;

CREATE OR REPLACE FILE FORMAT EXERCISE_DB.FILE_FORMAT.my_file_format
TYPE = CSV
FIELD_DELIMITER=','
SKIP_HEADER=1;

DROP TABLE EXERCISE_DB.NEW_SCHEMA.EMPLOYEES;

COPY INTO EXERCISE_DB.NEW_SCHEMA.EMPLOYEES
FROM @STAGE_DB.EXTERNAL_STAGES.STAGE3
FILE_FORMAT = EXERCISE_DB.FILE_FORMAT.my_file_format
ON_ERROR = 'CONTINUE';

CREATE OR REPLACE TABLE REJECTED AS 
SELECT REJECTED_RECORD FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));