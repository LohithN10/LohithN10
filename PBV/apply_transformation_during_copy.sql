// Transform using select statement , 
--select subset of columns

copy into db.s.t
from (select s.c1, s.c2 fom @db.s.stage s)  // s.$1,s.$2 selects first and second column
file_format = (type = csv field_delimeter=';' skip_header=1)
files = ('filename.csv') or
pattern =".*string_match*."


-- --  SQL functions  check documentation for available functions  
-- case when statements if required
-- substring(s.$4,1,5) --selects string with first five character here beggining and length is given

//Transform using subset of columns

copy into db.s.t (c1,c2)
from (select s.c1, s.c2 fom @db.s.stage s)  // s.$1,s.$2 selects first and second column
file_format = (type = csv field_delimeter=';' skip_header=1)
files = ('filename.csv') or
pattern =".*string_match*."

//Table auto increment
 create or replace table customers(   
     order_id number autoincrement start 1 increment 1,
     customer_id int,   
     first_name varchar,   
     last_name varchar,   
     email varchar,   
     age int,   
     city varchar) 

