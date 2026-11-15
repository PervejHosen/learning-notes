--Create a Database named TESTDB
CREATE DATABASE TESTDB

--If we wish to drop the database

--To use the database 
USE DATABASE TESTDB;

--now i want to create several tables under one schema and others under another schema
CREATE SCHEMA TESTDB.TEST1;

USE SCHEMA TESTDB.TEST1;

--TO Check if there is any existing table
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA= 'TEST1';

--CTAS: Create Table as Select from other table/query output
CREATE TABLE CUSTOMER AS 
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
WHERE C_MKTSEGMENT = 'HOUSEHOLD';


--TO CHECK A SAMPLE OF DATA IN THAT TABLE
SELECT * FROM TESTDB.TEST1.CUSTOMER LIMIT 10;

--AS DATABASE AND SCHEMA'S ARE SPECIFIED USING "USE" STATEMENT, YOU CAN IGNORE THE "TESTDB.TEST1." IN THE ABOVE COMMAND AND SIMPLY USE:
SELECT * FROM CUSTOMER LIMIT 10;

--To Check the Statement/Query that has been used create the table
SELECT get_ddl('table', 'CUSTOMER');

--DROP TABLE CUSTOMER;
DROP TABLE CUSTOMER;

--CREATE A TABLE MANUALLY USING PRECISION (number of digits/characters allowed before decimal place) AND SCALE (number of digits allowed after decimal place) 

CREATE OR REPLACE TABLE CUSTOMER (
	C_CUSTKEY NUMBER(16,0),
	C_NAME VARCHAR(25),
	C_ADDRESS VARCHAR(40),
	C_NATIONKEY NUMBER(38,0),
	C_PHONE VARCHAR(15),
	C_ACCTBAL NUMBER(12,2),
	C_MKTSEGMENT VARCHAR(10),
	C_COMMENT VARCHAR(255)
);

--The "Replace" statement ensures that if a same named table already exists, it will not give an error, rather replace the existing one

SELECT * FROM CUSTOMER;

--CREATE A CUSTOMER TABLE WITHOUT ANY PII (Personally Identifiable Information like ADDRESS, NATIONKEY, ACCOUNT BALANCE, PHONE NUMBER, ect.)
CREATE OR REPLACE TABLE CUSTOMER_RESTRICTED_INFO (
	C_CUSTKEY NUMBER(16,0),
	C_NAME VARCHAR(20),
	C_EDUCATION VARCHAR(10),
	C_DEPARTMENT VARCHAR(20)
);

--DROP TABLE CUSTOMER_RESTRICTED_INFO;
SELECT * FROM CUSTOMER_RESTRICTED_INFO;

--DML: Data Manipulation Language [INSERT, UPDATE, DELETE]
--"INSERT" TO ADD NEW RECORDS
INSERT INTO CUSTOMER_RESTRICTED_INFO (C_CUSTKEY, C_NAME, C_EDUCATION, C_DEPARTMENT)
VALUES (1001, 'Sabbir Hossain', 'MSc', 'Statistics');  
--FOR DATE AND VARCHAR USE SINGLE QUOTE

--Multiple Rows can be inserted at a time
INSERT INTO CUSTOMER_RESTRICTED_INFO (C_CUSTKEY, C_NAME, C_EDUCATION, C_DEPARTMENT)
VALUES 
    (1002, 'Pervej Hosen', 'MSc', 'Data Science'),
    (1003, 'Emma Watson', 'MSc', null),
    (1004, 'Sukanta Pramannik', 'BSc', 'CSE');
    
SELECT * FROM CUSTOMER_RESTRICTED_INFO;
--Lets check the null values
SELECT * FROM CUSTOMER_RESTRICTED_INFO 
WHERE C_DEPARTMENT IS NULL;

--lets fixed the null issues
--UPDATE TO UPDATE AN EXISTING RECORDS

UPDATE CUSTOMER_RESTRICTED_INFO
SET C_DEPARTMENT = 'History'
WHERE C_CUSTKEY = 1003;

--lets see the fixed table now
SELECT * FROM CUSTOMER_RESTRICTED_INFO;

--"DELETE" CAN BE DIRECTLY USED WHERE IT DELETES ALL THE RECORDS IN THE TABLE
--BUT IT SHOULD BE USED WITH A "WHERE" CLAUSE TO DELETE SPECIFIC RECORDS
DELETE FROM CUSTOMER_RESTRICTED_INFO 
WHERE C_CUSTKEY = 1003;

select * from customer_restricted_info;
--DELETE FROM CUSTOMER_RESTRICTED_INFO;

--"TRUNCATE" SHOULD BE USED TO DROP ALL THE RECORDS FROM A DATABASE TABLE
--IT'S FASTER THAN THE "DELETE" STATEMENT
TRUNCATE CUSTOMER_RESTRICTED_INFO;
SELECT * FROM CUSTOMER_RESTRICTED_INFO;

--What is difference between DROP & TRUNCATE?
--DROP REMOVES A TABLE/DATABASE/SCHEMA
--TRUNCATE ONLY REMOVES ALL THE ROWS IN THE TABLE; BUT, TABLE STRUCTURE IS UN-AFFECTED
--IT DROPS ALL THE RECORDS AT A ONCE (CLEAN THE TABLE), BUT DOES NOT AFFECT THE SCHEMA/TABLE STRUCTURE

--TO DROP A TABLE, SCHEMA OR DATABASE WE USE THE "DROP" STATEMENT
DROP TABLE CUSTOMER_RESTRICTED_INFO;

SELECT * FROM CUSTOMER_RESTRICTED_INFO;--WILL GIVE YOU ERROR AS THERE IS NO TABLE IN THAT NAME

--However, When we are working with multiple interconnected (with primary and foreign keys) tables, we need to use "CASCADE" Statement

DROP TABLE IF EXISTS CUSTOMER_RESTRICTED_INFO CASCADE;

--CLEANING THE ENVIRONMENT
DROP TABLE CUSTOMER;
DROP DATABASE TESTDB;

--DCL: Data Control Language
--Transaction Starts with Begin
BEGIN;
--Commits all your changes in Database
COMMIT;
--Rollbacks your updates if commit is not issued
ROLLBACK;

-- ################    Bulk Insert Employee Data ###############---  

CREATE OR REPLACE DATABASE EMPLOYEE_DB;
USE DATABASE EMPLOYEE_DB;
CREATE SCHEMA EMP;
USE SCHEMA EMPLOYEE_DB.EMP;

--Create Table in Snowflake using Create Statement
CREATE OR REPLACE TABLE EMPLOYEES (
EMPLOYEE_ID number (10),
FIRST_NAME varchar(25),
LAST_NAME varchar(25),
EMAIL varchar(25),
PHONE_NUMBER varchar(15),
HIRE_DATE DATE,
JOB_ID varchar(15),
SALARY  number(12,2),
COMMISSION_PCT  real,
MANAGER_ID number,
DEPARTMENT_ID number
);

SELECT * FROM EMPLOYEES;

--DDL COMMAND
alter table EMPLOYEES
drop column COMMISSION_PCT;

SELECT * FROM EMPLOYEES;

--DDL COMMAND
alter table EMPLOYEES
drop column COMMISSION_PCT;

SELECT * FROM EMPLOYEES;

--Show Column/Variable Types
show columns in table employees;

--SHOW TABLE NAMES AND TYPE OF THE TABLES IN A SCHEMA
SELECT table_name, table_type 
FROM EMPLOYEE_DB.information_schema.tables 
WHERE table_schema = 'EMP';

--CHECK IF THERE'S ANY CONSTRAINT
SELECT table_name, constraint_type, constraint_name
FROM EMPLOYEE_DB.information_schema.table_constraints
WHERE constraint_schema = 'EMP'
ORDER BY table_name;

--CREATE A FILE FORMAT TO LOAD THAT FORMAT DATA INTO SNOWFLAKE [To Bulk Insert CSV Files]
create or replace file format my_csv_format
  type = csv
  field_delimiter = ','
  skip_header = 1
  null_if = ('NULL', 'null')
  empty_field_as_null = true
  --field_optionally_enclosed_by = '\042'
  --field_optionally_enclosed_by = '\027'
  --compression = gzip
  ;

--DROP FILE FORMAT my_csv_format;
  
select * from employees;



SELECT * FROM EMPLOYEES E WHERE E.HIRE_DATE IS NULL;
--SELECT * FROM EMPLOYEES E WHERE E.HIRE_DATE = ''; --To check if there is any empty value

TRUNCATE employees;
