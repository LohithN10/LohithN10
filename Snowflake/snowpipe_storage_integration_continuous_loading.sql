
create warehouse pipe_wh;

create or replace database snowpipe;

create or replace storage integration azure_storage_integration
    type = external_stage
    storage_provider = Azure
    enabled = true  
    azure_tenant_id = '2d2199a8-cb98-4269-b2ae-c63cf2b7c7f0'
    storage_allowed_locations = ('azure://snowpipelohith107.blob.core.windows.net/snowpipe');

desc storage integration azure_storage_integration;
//request permission for the concent url

create or replace file format azure_file_format
    type = csv 
    field_delimiter =','
    skip_header = 1;

create or replace stage snowpipe.public.azure_sf
storage_integration = azure_storage_integration
url='azure://snowpipelohith107.blob.core.windows.net/snowpipe'
file_format = azure_file_format;

list @snowpipe.public.azure_sf;

// Notification integration

create or replace notification integration snowpipe_event
enable =true
type = queue
notification_provider= azure_storage_queue
azure_storage_queue_primary_uri = 'url with https'
azure_tenant_id ='tenant_id';

desc notification integration snowpipe_event;

// creating snowpipe

create pipe azure_pipe
auto_ingest= true
integration = 'snowpipe_event'
as
copy into snowpipe.public.continous_table
from @snowpipe.public.azure_sf;


alter pipe azure_pipe refresh;

//to check error

select system$pipe_status('pipe_name');
