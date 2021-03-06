--------------------------------------------------
--TABLES
--------------------------------------------------

CREATE TABLE EMPLOYEES(
EMPLOYEE_ID  INT NOT NULL,
FNAME VARCHAR(20) NOT NULL,
MIDDLE_NAME VARCHAR(20) NULL,
LNAME VARCHAR(20) NOT NULL,
ADDRESS VARCHAR(30) NOT NULL,
PHONE_NUMBER VARCHAR(15) NOT NULL,
EMAIL VARCHAR(25) not null,
POSITION VARCHAR(20) NOT NULL,
DEPARTMENT_ID INT NOT NULL,
MANAGER_ID INT NULL,
SALARY NUMERIC NOT NULL,
 CONSTRAINT PK_EMP PRIMARY KEY(EMPLOYEE_ID),
 CONSTRAINT UK_EMP UNIQUE (EMAIL),
 constraint EMP_DEPT_FK foreign key (DEPARTMENT_ID)
 references DEPARTMENTS (DEPARTMENT_ID)
)

CREATE TABLE DEPARTMENTS(
DEPARTMENT_ID INT NOT NULL,
NAME VARCHAR(30) NOT NULL,
CONSTRAINT PK_DEPT PRIMARY KEY(DEPARTMENT_ID)
)

CREATE TABLE CLIENTS (
	CLIENT_ID INT NOT NULL,
	FNAME VARCHAR(30) NOT NULL,
	MIDDLE_NAME VARCHAR(30) NULL,
	LNAME VARCHAR(30) NOT NULL,
	PHONE_NUMBER VARCHAR(255) NOT NULL,
	ADDRESS VARCHAR(30) NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,
	BANK_ACCOUNT INT NULL,
	CONSTRAINT PK_CLIENTS PRIMARY KEY (CLIENT_ID),
	constraint UK_CLIENTS unique (BANK_ACCOUNT)	
)

--------------------------------------------------
--INSERTS

INSERT INTO DEPARTMENTS
VALUES (1, 'OPERATIONS')
INSERT INTO DEPARTMENTS
VALUES (2, 'CREDITS ANALYSE')
INSERT INTO DEPARTMENTS
VALUES (3, 'ACCOUNTANCY')

INSERT INTO EMPLOYEES
VALUES (1, 'IVAN', NULL, 'PETROV','BG', '9898989', 'AAA@AAA', 'OPERATOR', 1, 2, '1500')
INSERT INTO EMPLOYEES 
VALUES (2, 'STOQN', 'STOQNOV', 'IVANOV','BG', '9898989', 'BBB@BB', 'ANALYSATOR', 2, 3, '2000')
INSERT INTO EMPLOYEES 
VALUES (3, 'PETAR', NULL, 'PETROV','BG', '9898989', 'CCC@CC', 'ACCOUNTANT', 3, 1, '2500')
INSERT INTO EMPLOYEES 
VALUES (4, 'GEORGE', NULL, 'KING','USA', '9890989', 'DDD@DD', 'OPERATOR', 1, 4, '3000')
INSERT INTO EMPLOYEES 
VALUES (5, 'IORDAN', 'PETROV', 'GEORGIEV','BG', '9890989', 'EEE@EE', 'ANALYSATOR', 2, 1, '3500')
INSERT INTO EMPLOYEES 
VALUES (6, 'STEVEN', NULL, 'KING','EN', '9890989', 'FFF@FF', 'ACCOUNTANT', 3, 3, '5000')

INSERT INTO CLIENTS
VALUES(1, 'IVAN', 'DIMITROV', 'IVANOV', '089999999', 'BG', 'IVAN@A', 100)
INSERT INTO CLIENTS
VALUES(2, 'PETKO', 'DIMITROV', 'STOQNOV', '089999999', 'UK', 'PETKO@B', 450)
INSERT INTO CLIENTS
VALUES(3, 'GERGI', 'IVANOV', 'GEORGIEV', '08998889', 'BG', 'GEORGI@G', 1000)




------------------------------------------------------------------------
--BUSINESS QUERIES PART 1

----The names of all departments in the bank
SELECT NAME 
FROM DEPARTMENTS

--The names and salaries of the employees in the company
SELECT FNAME, LNAME, SALARY
FROM EMPLOYEES

--Selects from employeesthe first name, last name and a new e-mail, that are concatenated first and last names, seperate by a dot.
--The names should be with a lower cases in the new email. 

SELECT FNAME, LNAME, LOWER(CONCAT(CONCAT(FNAME, '.'), LNAME)) AS EMAIL
FROM EMPLOYEES
GROUP BY FNAME, LNAME, EMAIL

-- Updating for the next query - "All the senior employees in the company - the senior are the ones that have been working in the company for more than 5 years."
ALTER TABLE EMPLOYEES_TEST11
ADD HIRE_DATE DATE NULL

UPDATE EMPLOYEES
SET HIRE_DATE = TO_DATE('2003/05/03', 'yyyy/mm/dd')
WHERE EMPLOYEE_ID=1

UPDATE EMPLOYEES
SET HIRE_DATE = TO_DATE('2007/04/02', 'yyyy/mm/dd')
WHERE EMPLOYEE_ID=2

UPDATE EMPLOYEES
SET HIRE_DATE = TO_DATE('2016/08/04', 'yyyy/mm/dd')
WHERE EMPLOYEE_ID=3

UPDATE EMPLOYEES
SET HIRE_DATE = TO_DATE('2017/08/04', 'yyyy/mm/dd')
WHERE EMPLOYEE_ID=4

UPDATE EMPLOYEES
SET HIRE_DATE = TO_DATE('2010/08/04', 'yyyy/mm/dd')
WHERE EMPLOYEE_ID=5

UPDATE EMPLOYEES
SET HIRE_DATE = TO_DATE('2015/08/04', 'yyyy/mm/dd')
WHERE EMPLOYEE_ID=6

--All the senior employees in the company - the senior are the ones that have been working in the company for more than 5 years.
SELECT * FROM EMPLOYEES 
WHERE HIRE_DATE < TO_DATE('2014/01/17', 'yyyy/mm/dd')
--second way
SELECT FNAME, LNAME
FROM EMPLOYEES
WHERE (TO_CHAR(CURRENT_DATE,'YYYY') - TO_CHAR(HIRE_DATE, 'YYYY')) > 5


--Selects all the first names that start with the word "S" from employees
SELECT FNAME, LNAME
FROM EMPLOYEES
WHERE FNAME LIKE 'S%'

--All the employees that are not born in Bulgaria
SELECT * FROM EMPLOYEES
WHERE ADDRESS NOT LIKE 'BG'

--Selects all the employees which first, last, or surname contanins the word "l"
SELECT FNAME, SUR_NAME, LNAME
FROM EMPLOYEES
WHERE FNAME LIKE  '%l%' OR SUR_NAME LIKE  '%l%' OR LNAME LIKE  '%l%'


------------------------------------------------------------------------
--BUSINESS QUERIES PART 2

CREATE TABLE DEP_CHANGE --Table which shows how employees change their departments
(
   EMPLOYEE_ID NUMBER NOT NULL REFERENCES EMPLOYEES(EMPLOYEE_ID),
   DEPARTMENT_ID NUMBER NOT NULL REFERENCES DEPARTMENTS(DEPARTMENT_ID),
   CHANGE_DEP_DATE DATE NOT NULL,
   PRIMARY KEY(EMPLOYEE_ID, DEPARTMENT_ID, CHANGE_DEP_DATE) 
)

--Inserts 
INSERT INTO DEP_CHANGE(EMPLOYEE_ID, DEPARTMENT_ID, CHANGE_DEP_DATE)
VALUES(100, 100, TO_DATE('12-05-2011', 'DD/MM/YYYY'))

INSERT INTO DEP_CHANGE(EMPLOYEE_ID, DEPARTMENT_ID, CHANGE_DEP_DATE)
VALUES(103, 30, TO_DATE('06-10-2016', 'DD/MM/YYYY'))

INSERT INTO DEP_CHANGE(EMPLOYEE_ID, DEPARTMENT_ID, CHANGE_DEP_DATE)
VALUES(108, 50, TO_DATE('10-01-2019', 'DD/MM/YYYY'))

INSERT INTO DEP_CHANGE(EMPLOYEE_ID, DEPARTMENT_ID, CHANGE_DEP_DATE)
VALUES(105, 10, TO_DATE('27-12-2018', 'DD/MM/YYYY'))

--Selects all the employees, that have changed their departments in the last 2 months
SELECT FNAME, LNAME, CHANGE_DEP_DATE
FROM EMPLOYEES E JOIN DEP_CHANGE DC
ON E.EMPLOYEE_ID = DC.EMPLOYEE_ID
WHERE MONTHS_BETWEEN (TO_DATE(CURRENT_DATE, 'DD/MM/YYYY'), TO_DATE(CHANGE_DEP_DATE, 'DD/MM/YYYY')) < 3

--Selects all the employees that have not changed their departments since the start date of their job
SELECT FNAME, LNAME, E.EMPLOYEE_ID
FROM EMPLOYEES E LEFT JOIN DEP_CHANGE DM
ON E.EMPLOYEE_ID = DM.EMPLOYEE_ID
WHERE CHANGE_DEP_DATE IS NULL

------------------------------------------------------------------------
--BUSINESS QUERIS PART 3

--Selects all the emloyees that have been hired from the company
ALTER TABLE EMPLOYEES
ADD STATUS VARCHAR2(30) DEFAULT 'WORKING'

UPDATE EMPLOYEES
SET STATUS = 'FIRED'
WHERE EMPLOYEE_ID = 100

SELECT FNAME, LNAME
FROM EMPLOYEES
WHERE STATUS = 'FIRED'

--The employees that are in maternity
UPDATE EMPLOYEES
SET STATUS = 'MATERNITY'
WHERE EMPLOYEE_ID = 101

SELECT FNAME, LNAME
FROM EMPLOYEES
WHERE STATUS = 'MATERNITY'

--The employees that are in hospital or on a holiday at the moment
UPDATE EMPLOYEES
SET STATUS = 'HOSPITAL'
WHERE EMPLOYEE_ID = 109

UPDATE EMPLOYEES
SET STATUS = 'Holiday'
WHERE EMPLOYEE_ID = 106

SELECT FNAME, LNAME
FROM EMPLOYEES
WHERE STATUS = 'HOSPITAL' OR STATUS = 'Holiday'

--Employees with a salary between 2000 and 3000
SELECT * FROM EMPLOYEES 
WHERE SALARY BETWEEN 2000 AND 3000

--The employees with a salary of 2500, 3000, 3500 or 5000
SELECT FNAME, LNAME 
FROM EMPLOYEES
WHERE SALARY = 2500 OR SALARY = 3000 OR SALARY = 3500 OR SALARY = 5000

--Employees that are without a manager
SELECT FNAME, LNAME
FROM EMPLOYEES
WHERE MANAGER_ID IS NULL


--
--Inserts, needed for the next query - "Employees with a salary, higher than 5000, arranged by their first name descending"
INSERT INTO EMPLOYEES 
VALUES (8, 'STEVE', 'GEORGIEV', 'GEORGIEV','RUS', '9999999', 'HHH@HHH', 'OPERATOR', 3, 1, '6000',
 TO_DATE('2012/01/17', 'yyyy/mm/dd'), NULL )
 INSERT INTO EMPLOYEES 
VALUES (9, 'DIMITAR', 'DIMITROV', 'IORDANOV','BG', '10101010', 'III@III', 'OPERATOR', 1, 1, '6000',
 TO_DATE('2010/01/17', 'yyyy/mm/dd'), NULL )

UPDATE EMPLOYEES
SET EMAIL = LOWER(CONCAT(CONCAT(FNAME,'.'), LNAME)) 
WHERE EMPLOYEE_ID = 8

UPDATE EMPLOYEES
SET EMAIL = LOWER(CONCAT(CONCAT(FNAME,'.'), LNAME)) 
WHERE EMPLOYEE_ID = 9

--Employees with a salary, higher than 5000, arranged by theit first name descending
SELECT FNAME, LNAME
FROM EMPLOYEES
WHERE (TO_CHAR(CURRENT_DATE,'YYYY') - TO_CHAR(HIRE_DATE, 'YYYY')) > 5
AND SALARY > 5000
ORDER BY FNAME DESC

--First 5 best paid employeed, grouped by departments
SELECT FNAME, LNAME, SALARY
FROM(SELECT FNAME, LNAME, D.DEPARTMENT_ID, SALARY
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID, FNAME, LNAME, SALARY
ORDER BY SALARY DESC)
WHERE ROWNUM < 6

--Departments in which the employees get the lowest salary
SELECT NAME
FROM(SELECT NAME, D.DEPARTMENT_ID, SUM(SALARY)
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY NAME, D.DEPARTMENT_ID, SALARY
ORDER BY SALARY)
WHERE ROWNUM < 2

--Average salary, grouped by department name and department id 
SELECT AVG(SALARY) AS AVG_SALARY, NAME, D.DEPARTMENT_ID
FROM DEPARTMENTS D JOIN EMPLOYEES E 
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY NAME, D.DEPARTMENT_ID


--Departments in which the employees get the lowest salary
SELECT NAME
FROM(SELECT NAME, D.DEPARTMENT_ID, SUM(SALARY)
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY NAME, D.DEPARTMENT_ID, SALARY
ORDER BY SALARY)
WHERE ROWNUM < 2

--second way
SELECT DEPARTMENT_ID, MIN(SALARY) AS MINIMUM
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID


--Average salary, grouped by department name and department id 
SELECT AVG(SALARY) AS AVG_SALARY, NAME, D.DEPARTMENT_ID
FROM DEPARTMENTS D JOIN EMPLOYEES E 
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY NAME, D.DEPARTMENT_ID

--second way
SELECT DEPARTMENT_ID, AVG(SALARY) AS AVG
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID



