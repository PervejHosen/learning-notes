--  ########## Normalization in Database; Keys & Constraints  ###########  --
USE DATABASE EMPLOYEE_DB;

CREATE SCHEMA BOOKS_SCHEMA;
USE SCHEMA BOOKS_SCHEMA;

--Primary Key      
CREATE OR REPLACE TABLE USERS (
  id NUMBER(6) autoincrement start 100 increment 1,
  username VARCHAR(25) NOT NULL,
  enabled BOOLEAN DEFAULT TRUE, --BOOLEAN: TRUE/FALSE
  last_login timestamp NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
--DROP TABLE USERS;

SELECT * FROM USERS;


--Unique Constraint
CREATE TABLE BOOKS (
  id NUMBER(6) autoincrement start 1 increment 1,
  title VARCHAR(100) NOT NULL,
  author VARCHAR(100) NOT NULL,
  published_date date NOT NULL,
  isbn NUMBER(10),
  PRIMARY KEY (id),
  UNIQUE (isbn)
);


--Foreign Key
CREATE OR REPLACE TABLE REVIEWS (
  id NUMBER(6) autoincrement start 1 increment 1,
  book_id NUMBER (6) NOT NULL,
  user_id NUMBER (6) NOT NULL,
  review_content VARCHAR(255),
  rating NUMBER (1,1),
  published_date timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

--Composite Key as Primary Key
CREATE TABLE users_books (
  user_id NUMBER(6) NOT NULL ,
  book_id NUMBER(6) NOT NULL,
  checkout_date timestamp,
  return_date timestamp,
  PRIMARY KEY (user_id, book_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON UPDATE CASCADE
);

/*
--Check Constraint
CREATE TABLE people(
age NUMBER(6) CHECK (age > 0)
);
*/

--Alter a Table
--Adding a column to a table
ALTER TABLE                                 -- this statement alters
users                                       -- the table users
ADD COLUMN                                  -- by adding a column
email varchar(20) NOT NULL; -- using these options


select * from users;

--Renaming a column

alter table users rename column USERNAME to NAMES;--USERNAME TO NAMES

--Dropping a column

ALTER TABLE users DROP COLUMN enabled;

DROP TABLE REVIEWS;

DROP TABLE USERS;

CREATE TABLE users (
  id NUMBER(6) autoincrement start 1 increment 1 PRIMARY KEY,
  username VARCHAR(25) NOT NULL,
  enabled boolean DEFAULT TRUE
);

INSERT into users(username, enabled)
VALUES('John Smith', false);

SELECT * FROM users;

INSERT into users(username, enabled)
VALUES('John Smith II', false);
INSERT into users(username, enabled)
VALUES('John Smith III', false);
INSERT into users(username, enabled)
VALUES('John Smith III', true);
INSERT into users(username, enabled)
VALUES('Jack Smith III', true);
INSERT into users(username, enabled)
VALUES('Jack Smith II', true);
INSERT into users(username, enabled)
VALUES('Jack Smith I', true);

SELECT * FROM USERS;

UPDATE users SET enabled = true
WHERE rtrim(username) LIKE '%II';--Change enabled to true for all users whose name contains II.

/*
rtrim is a function we can use to remove whitespace to the right of a data field. 
Its use is necessary in the above SQL statement, otherwise we won't get a correct match with our LIKE clause. 
'%' This is a wild card, telling the SQL LIKE clause to allow any number of characters.
*/

DELETE FROM users
	WHERE username = 'John Smith';

TRUNCATE USERS;


/*
In PostgreSQL, the CASCADE option is used with the DROP TABLE statement to drop/delete a table and its dependent objects. 
To do so, specify the DROP TABLE command followed by the table name and then write the CASCADE to drop a table along with its dependent objects. 
*/

CREATE TABLE employees (
    emp_no INT NOT NULL PRIMARY KEY
);

CREATE TABLE salaries (
    Id INT NOT NULL,
    emp_no INT NOT NULL,
    FOREIGN KEY (emp_no)
        REFERENCES employees (emp_no)
        ON DELETE CASCADE
);

INSERT INTO employees VALUES (10001),
(10002);

INSERT INTO salaries VALUES (1, 10001),
(2, 10002);

SELECT * FROM employees e;

SELECT * FROM salaries s;

DELETE FROM employees e where e.emp_no = 10001;

SELECT * FROM employees e;
SELECT * FROM salaries s;








--  ########  Bulk Insert: Exception/Error Handling   ################  --
CREATE SCHEMA BULK;
USE SCHEMA BULK;

--Table & File Format Along with Copy Command
create or replace transient table customer_csv (
	customer_pk number(38,0),
	salutation varchar(10),
	first_name varchar(20),
	last_name varchar(30),
	gender varchar(1),
	marital_status varchar(1),
	day_of_birth date,
	birth_country varchar(60),
	email_address varchar(50),
	city_name varchar(60),
	zip_code varchar(10),
	country_name varchar(20),
	gmt_timezone_offset number(10,2),
	preferred_cust_flag boolean,
	registration_time timestamp_ltz(9)
);

create or replace file format customer_csv_ff 
    type = 'csv' 
    compression = 'none' 
    field_delimiter = ','
    skip_header = 1 ;

TRUNCATE customer_csv;
    

-- field optionally enclosed
create or replace file format customer_csv_ff2
    type = 'csv' 
    compression = 'none' 
    field_delimiter = ','
    field_optionally_enclosed_by = '\042'
    skip_header = 1 ;

TRUNCATE customer_csv;

--File Format for PSV & TSV Delimited Data File

create or replace file format customer_tsv_ff 
    type = 'csv' 
    compression = 'none' 
    field_delimiter = '\t'
    field_optionally_enclosed_by = '\042'
    skip_header = 1 ;

create or replace file format customer_tsv_ff 
    type = 'csv' 
    compression = 'none' 
    field_delimiter = '|'
    field_optionally_enclosed_by = '\042'
    skip_header = 1 ;

--Copy Into Table Parameters

-- Option-1
-- On Error => Skip The file

COPY INTO "TTIPS"."CH01"."CUSTOMER_CSV" 
    FROM @/ui1664948747495 
    FILE_FORMAT = '"TTIPS"."CH01"."CUSTOMER_CSV_FF"' 
    ON_ERROR = 'SKIP_FILE' 
    PURGE = TRUE;
  
-- Option-2
-- On Error => Abort Statement

COPY INTO "TTIPS"."CH01"."CUSTOMER_CSV" 
    FROM @/ui1664948747495 
    FILE_FORMAT = '"TTIPS"."CH01"."CUSTOMER_CSV_FF"' 
    ON_ERROR = 'ABORT_STATEMENT' 
    PURGE = TRUE;

-- Option-3
-- On Error => Skip upto 10 error records
COPY INTO "TTIPS"."CH01"."CUSTOMER_CSV" 
    FROM @/ui1664948747495 
    FILE_FORMAT = '"TTIPS"."CH01"."CUSTOMER_CSV_FF"' 
    ON_ERROR = 'SKIP_FILE_10' 
    PURGE = TRUE;
    
-- Option-4
-- On Error => Continue even if there is an error
COPY INTO "TTIPS"."CH01"."CUSTOMER_CSV" 
    FROM @/ui1664948747495 
    FILE_FORMAT = '"TTIPS"."CH01"."CUSTOMER_CSV_FF"' 
    ON_ERROR = 'CONTINUE' 
    PURGE = TRUE;

