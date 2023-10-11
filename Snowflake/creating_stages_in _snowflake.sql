create or replace database stage_db;

create schema external_stages;

use schema stage_db.external_stages;

create or replace stage  aws_stage
url = 's3://snowflake-assignments-mc/loadingdata/'   --if the bucket is public we don't need the credentials
credentials = (aws_key_id='sdd',aws_secret_key='asd')  --not the best option to mention credentials in the stage object,
-- storage integration for storing the credentials in a secured way

-- To have a closer look at a stage we can desc the stage using the following command

desc stage aws_stage;

-- to change the credentials we can use the ALTER command

alter stage aws_stage
    set credentials = (aws_key_id = 'new', aws_secret_key='new');

// List files in the stage

LIST @aws_stage;

//Loading data from stage using COPY OPTIONS

-- first create a table in snowflake desired database
create or replace table customers (
ID int,
first_name varchar,
last_name varchar,
email varchar,
age int,
city varchar);


select * from customers;


create or replace stage  aws_stage
url = 's3://snowflake-assignments-mc/loadingdata/' ;

list @aws_stage;

copy into customers 
from @aws_stage
file_format =(type=csv field_delimiter=';' skip_header=1);
files=('filename.csv') //to select required files 
//OR
pattern = ".*order*."  //to select multiple files using wild card


/////--Course solution--///
---- Create stage & load data ----
 
-- create stage object
CREATE OR REPLACE STAGE EXERCISE_DB.public.aws_stage
    url='s3://snowflake-assignments-mc/loadingdata';

-- List files in stage
LIST @EXERCISE_DB.public.aws_stage;

-- Load the data 
COPY INTO EXERCISE_DB.PUBLIC.CUSTOMERS
    FROM @aws_stage
    file_format= (type = csv field_delimiter=';' skip_header=1)

////////////////////////

