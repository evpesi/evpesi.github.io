CREATE WAREHOUSE CMS_WH;
CREATE DATABASE CMS_DB;
CREATE SCHEMA CMS_DB.prod;

--Create a storage integration to connect to the S3 bucket
CREATE STORAGE INTEGRATION my_s3_integration
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::396913706362:role/Snowflake-role-evan-data-project'
STORAGE_ALLOWED_LOCATIONS = ('s3://evan-data-project/CMS_data/');

--Gets information required to finish connecting AWS to S3 bucket
DESC INTEGRATION my_s3_integration;

--Create an external stage to load the data into
CREATE OR REPLACE STAGE my_s3_stage
URL = 's3://evan-data-project/CMS_data/'
STORAGE_INTEGRATION = my_s3_integration
FILE_FORMAT = csv_format;

--Create a file format to load the data into 
CREATE OR REPLACE FILE FORMAT csv_format
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
NULL_IF = ('NULL', 'null') 
EMPTY_FIELD_AS_NULL = true
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
ESCAPE_UNENCLOSED_FIELD = None

--Create a table to load the data into (the data is very dirty so we need to bring it in as strings or the load will fail)
CREATE OR REPLACE TABLE CMS_Unplanned_Hospital_Visits
(
    Facility_ID VARCHAR(10),
    Facility_Name VARCHAR(255),
    Address VARCHAR(255),
    City_Town VARCHAR(255),
    State VARCHAR(15),
    Zip_Code VARCHAR(50),
    County_Parish VARCHAR(255),
    Telephone VARCHAR(50),
    Measure_ID VARCHAR(50),
    Measure_Name VARCHAR(255),
    Compared_to_National VARCHAR(255),
    Denominator VARCHAR(50),
    Score VARCHAR(50),
	Lower_Est VARCHAR(50),
	Higher_Est VARCHAR(50),
	Number_Patients VARCHAR(50),
	Number_Patients_Returned VARCHAR(50),
	Footnote VARCHAR(50),
	Start_Date VARCHAR(50),
	End_Date VARCHAR(50)
);

--Finally, load the data into the table!
copy into CMS_Unplanned_Hospital_Visits from @my_s3_stage
ON_ERROR = 'skip_file';