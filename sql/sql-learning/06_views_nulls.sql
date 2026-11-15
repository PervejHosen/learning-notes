---TO SEE MISSING VALUE AS NULL
SELECT * FROM ORDERS 
WHERE O_COMMENT IS NULL
LIMIT 5;

--- TO SEE MISSING VALUE AS BLANK
SELECT * FROM ORDERS
WHERE O_COMMENT = ''
LIMIT 5;

/*
---ERROR HANDLING
---COALESCE [FIRST NOT MISSING ARGUMENT]

Returns the first non-NULL expression among its arguments, or NULL if all its arguments are NULL.
COALESCE (A,B,C)

NULLIF, IFNULL

A = 2, B = 0
IFERROR (A/B, 0)
*/

---Views
--Cleaned Data View
CREATE VIEW CLEANED_DATA AS

(
WITH FIVE_NUMBER_SUMMARY AS
(SELECT 
MIN(O_TOTALPRICE) AS MIN_ORDER_VALUE,
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY O_TOTALPRICE) AS Q1,
PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY O_TOTALPRICE) AS MEDIAN,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY O_TOTALPRICE) AS Q3,
MAX(O_TOTALPRICE) AS MAX_ORDER_VALUE,
(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY O_TOTALPRICE)-PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY O_TOTALPRICE)) AS IQR
FROM ORDERS),
HINGES AS
(SELECT (Q1-1.5*IQR) AS LOWER_HINGE, (Q3+1.5*IQR) AS UPPER_HINGE
FROM FIVE_NUMBER_SUMMARY AS F)


SELECT O_TOTALPRICE FROM ORDERS
WHERE O_TOTALPRICE > (SELECT LOWER_HINGE FROM HINGES) AND O_TOTALPRICE < (SELECT UPPER_HINGE FROM HINGES)
);



SELECT year(O_ORDERDATE) AS YEARS, month(O_ORDERDATE) AS MONTHS, round(sum(O_TOTALPRICE),0) AS TOTAL_SALES
FROM ORDERS
GROUP BY 1,2
ORDER BY 1,2;

--There are two types of view in General: Standard View (VIEW), Materialized View
--In Snowflake there are three types of Views: Standard View (VIEW), Materialized View, Secure View

--If you want to share your views with other users, then you need to create Secure View
--View (Standard View) doesn't consume any storage; It just store logics and calculation on the Metadata
--and It always refreses; So, no need to manually update this view

--Materialized View consumes space on databases. It takes a snapshot of the database during its' creation
