Learned Topics: [SELECT, FROM, LIMIT, SUM, ROUND, AS, ALIAS, AVG, MIN, MAX, GROUP BY, ORDER BY, ASC, DESC, JOINING TABLE, LEFT JOIN, MAKING CHARTS FROM ANSWEER]


---Cheking the first 10 row of the table

SELECT*from call_center limit 10;
select*FROM CUSTOMER LIMIT 10;

---Findings KPI

SELECT 
ROUND(sum(C_ACCTBAL),0) AS Total_Balance,
ROUND(avg(C_ACCTBAL),0) AS Average_Balance,
round(min(c_acctbal),0) as Minimum_Balance,
round(max(c_acctbal),0) as Maximum_Balance
FROM CUSTOMER;

----Groupby

SELECT C_MKTSEGMENT,
ROUND(sum(C_ACCTBAL),0) AS Total_Balance,
ROUND(avg(C_ACCTBAL),0) AS Average_Balance,
round(min(c_acctbal),0) as Minimum_Balance,
round(max(c_acctbal),0) as Maximum_Balance
FROM CUSTOMER
GROUP BY C_MKTSEGMENT;
---AS stand for ALIASING

---Region wise groupby

SELECT c_nationkey, C_MKTSEGMENT,
ROUND(sum(C_ACCTBAL),0) AS Total_Balance,
ROUND(avg(C_ACCTBAL),0) AS Average_Balance,
round(min(c_acctbal),0) as Minimum_Balance,
round(max(c_acctbal),0) as Maximum_Balance
FROM CUSTOMER
GROUP BY 1, 2
ORDER BY 1, 2;

----lets see what nation key table show us

SELECT * FROM NATION LIMIT 5;

----lets join Nation table and Customer table

SELECT N_NAME as Nation_Name, C_MKTSEGMENT as Market_Segment,
ROUND(sum(C_ACCTBAL),0) AS Total_Balance,
ROUND(avg(C_ACCTBAL),0) AS Average_Balance,
round(min(c_acctbal),0) as Minimum_Balance,
round(max(c_acctbal),0) as Maximum_Balance
FROM CUSTOMER
left join NATION ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY
GROUP BY 1, 2
ORDER BY 1, 2;

---Lets see which country has the most Balance
---Asc by Nation and Desc by Balance

SELECT N_NAME AS Nation_Name, C_MKTSEGMENT,
round(sum(C_ACCTBAL),0) AS Total_Balance 
FROM CUSTOMER
LEFT JOIN NATION ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY
GROUP BY 1, 2
ORDER BY 1 ASC, 3 DESC;

---Lets explore region table

SELECT * FROM REGION LIMIT 5;
SELECT * FROM NATION LIMIT 5;

---Lets join nation and region table 
---and create a report by region instead of nation

SELECT R_NAME AS Region_Name, C_MKTSEGMENT,
round(sum(C_ACCTBAL),0) AS Total_Balance 
FROM CUSTOMER
LEFT JOIN NATION ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY
LEFT JOIN REGION ON NATION.N_REGIONKEY=NATION.N_REGIONKEY
GROUP BY 1, 2
ORDER BY 1 ASC, 3 DESC;

