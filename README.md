# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/najirh/Library-System-Management---P2/blob/main/library_erd.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
-- Library Management System


-- Creating Branch Table:
DROP TABLE IF EXISTS BRANCH;
CREATE TABLE BRANCH(
	branch_id VARCHAR(10) PRIMARY KEY,
	manager_id VARCHAR(10),
	branch_address VARCHAR(55),
	contact_no VARCHAR(15)
);


-- Creating Employees Table:
DROP TABLE IF EXISTS EMPLOYEES;
CREATE TABLE EMPLOYEES(
	emp_id VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(25),
	position VARCHAR(20),
	salary FLOAT,
	branch_id VARCHAR(10) -- FK
);


-- Creating Books Table:
DROP TABLE IF EXISTS BOOKS;
CREATE TABLE BOOKS(
	isbn VARCHAR(25) PRIMARY KEY,
	book_title VARCHAR(75),
	category VARCHAR(15),
	rental_price FLOAT,
	status VARCHAR(15),
	author VARCHAR(35),
	publisher VARCHAR(60)
);


-- Creating Table Members:
DROP TABLE IF EXISTS MEMBERS;
CREATE TABLE MEMBERS(
	member_id VARCHAR(10) PRIMARY KEY,
	member_name VARCHAR(30),
	member_address VARCHAR(75),
	reg_date DATE
);


-- Creating Table Issued Status Table:
DROP TABLE IF EXISTS ISSUED_STATUS;
CREATE TABLE ISSUED_STATUS(
	issued_id VARCHAR(15) PRIMARY KEY,
	issued_member_id VARCHAR(10), -- FK
	issued_book_name VARCHAR(75),
	issued_date DATE,
	issued_book_isbn VARCHAR(25), -- FK
	issued_emp_id VARCHAR(10) -- FK
);


--Creating Return Status Table:
DROP TABLE IF EXISTS RETURN_STATUS;
CREATE TABLE RETURN_STATUS(
	return_id VARCHAR(10) PRIMARY KEY,
	issued_id VARCHAR(15),
	return_book_name VARCHAR(75),
	return_date DATE,
	return_book_isbn VARCHAR(25)
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO BOOKS(ISBN,BOOK_TITLE,CATEGORY,RENTAL_PRICE,STATUS,AUTHOR,PUBLISHER)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT * FROM BOOKS;
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE MEMBERS
SET MEMBER_ADDRESS = '141 Apple St'
WHERE member_id = 'C101';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM ISSUED_STATUS
WHERE issued_id = 'IS121';

SELECT * FROM ISSUED_STATUS;
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT ISSUED_BOOK_NAME
FROM ISSUED_STATUS
WHERE ISSUED_EMP_ID = 'E101';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT 
	ISSUED_MEMBER_ID,
	COUNT(ISSUED_BOOK_NAME)
FROM ISSUED_STATUS
GROUP BY ISSUED_MEMBER_ID
HAVING COUNT(ISSUED_BOOK_NAME) > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE BOOK_COUNT
AS
            SELECT 
                        B.ISBN,
                        B.BOOK_TITLE,
                        COUNT(IST.ISSUED_ID) AS No_ISSUED
            FROM BOOKS AS B
            JOIN ISSUED_STATUS AS IST
            ON IST.ISSUED_BOOK_ISBN = B.ISBN
            GROUP BY 1,2;
 
SELECT * FROM BOOK_COUNT;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM BOOKS
WHERE CATEGORY = 'History';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT 
	B.CATEGORY,
	SUM(B.RENTAL_PRICE) AS TOTAL_PRICE_BY_CATEGORY,
	COUNT(*)
FROM BOOKS AS B
JOIN ISSUED_STATUS AS IST
ON B.ISBN = IST.ISSUED_BOOK_ISBN
GROUP BY B.CATEGORY;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
INSERT INTO 
	MEMBERS(MEMBER_ID,MEMBER_NAME,MEMBER_ADDRESS,REG_DATE)
VALUES
	('C120', 'Tony Stark', '3000 Love St', '2026-08-20'),
	('C121', 'Steve Rogers', '1234 Army St', '2026-08-21');

SELECT CURRENT_DATE;

SELECT * FROM MEMBERS
WHERE REG_DATE >= CURRENT_DATE - INTERVAL '180 DAYS';
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
	E1.EMP_ID,
	E1.EMP_NAME,
	E1.POSITION,
	E1.SALARY,	
	B.BRANCH_ID,
	E2.EMP_ID AS MANAGER_ID,
	E2.EMP_NAME AS MANAGER_NAME
FROM EMPLOYEES AS E1
JOIN BRANCH AS B
ON B.BRANCH_ID = E1.BRANCH_ID
JOIN EMPLOYEES AS E2
ON B.MANAGER_ID = E2.EMP_ID;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
SELECT * FROM BOOKS;

CREATE TABLE RTP8_BOOKS
AS
	SELECT * 
	FROM BOOKS
	WHERE RENTAL_PRICE>8;

SELECT * FROM RTP8_BOOKS;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT 
	IST.*
FROM ISSUED_STATUS AS IST
LEFT JOIN RETURN_STATUS AS RST
ON RST.ISSUED_ID = IST.ISSUED_ID
WHERE RST.RETURN_ID IS NULL
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT CURRENT_DATE;

SELECT 
	MB.MEMBER_ID,
	MB.MEMBER_NAME,
	IST.ISSUED_BOOK_NAME,
	IST.ISSUED_DATE,
	CURRENT_DATE-IST.ISSUED_DATE OVER_DUE_DAYS
FROM ISSUED_STATUS IST
JOIN MEMBERS MB
ON IST.ISSUED_MEMBER_ID = MB.MEMBER_ID
LEFT JOIN RETURN_STATUS RST
ON IST.ISSUED_ID = RST.ISSUED_ID
WHERE RST.RETURN_ID IS NULL AND CURRENT_DATE-IST.ISSUED_DATE > 30
ORDER BY 1;
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
```sql
-- Store Procedure
-- Declaring a Function:
CREATE OR REPLACE PROCEDURE Add_Returned_Records(p_return_id VARCHAR(10), p_issued_id VARCHAR(15), p_book_quality VARCHAR(15)) -- 'p' Defines Parameters
LANGUAGE plpgsql
AS $$
DECLARE
	-- All the declarations of variables, which are used in the procedure
	v_isbn VARCHAR(50); 								-- DECLARING A VARIABLE 
	v_book_name VARCHAR(75);							 -- DECLARING A VARIABLE 
BEGIN
	-- All the logic of the code
	-- 1. AS-SOON-AS someone returns the book, it should be inserted in return_status FIRST!
	INSERT INTO RETURN_STATUS(RETURN_ID,ISSUED_ID,RETURN_DATE,BOOK_QUALITY)
	VALUES
		(p_return_id, p_issued_id, CURRENT_DATE, p_book_quality); -- NO '' WILL BE USED, BECAUSE THEY ARE PARAMETERS, NOT VALUES
	-- 2. UPDATING IN THE BOOKS TABLE, IF 'NOT AVAILABLE' SET TO 'AVAILABLE'
	SELECT 
		ISSUED_BOOK_ISBN,
		ISSUED_BOOK_NAME
		INTO  												-- STORING THE ISBN VALUE INTO VARIABLE(v_isbn)
			v_isbn,
			v_book_name
		FROM ISSUED_STATUS
		WHERE ISSUED_ID = p_issued_id; 						-- ASSIGNING ISSUED_ID TO ISSUED_ID FROM(UP-SIDE) INSERT VALUE I.E,. PARAMETER ISSUED_ID
	-- UPDATING
	UPDATE BOOKS		
	SET STATUS = 'yes'
	WHERE ISBN = v_isbn;
	RAISE NOTICE 'THANK YOU FOR RETURNING THE BOOK: %', v_book_name;
END;
$$


CALL Add_Returned_Records() -- Calling the function

-- TESTING (VERIFYING) Function Add_Returned_Records: WITH A RECORD WHICH WAS NOT YET RETURNED.
SELECT * FROM ISSUED_STATUS
WHERE ISSUED_BOOK_ISBN = '978-0-375-41398-8';

SELECT * FROM BOOKS
WHERE STATUS = 'no'
ISSUED_ID = 'IS135';

SELECT * FROM RETURN_STATUS;

SELECT * FROM RETURN_STATUS
WHERE ISSUED_ID = 'IS134';	-- NEXT RETURN ID SHOULD BE RS120

-- TESTING Function:
CALL Add_Returned_Records('RS120','IS135', 'Good');		-- PASSING 3 PARAMETERS

CALL Add_Returned_Records('RS121', 'IS134', 'Good'); 		-- PASSING 3 PARAMETERS

```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
CREATE TABLE branch_reports
AS
SELECT
	BR.BRANCH_ID,
	BR.MANAGER_ID,
	COUNT(IST.ISSUED_ID) AS No_Of_Books_Issued,
	COUNT(RTS.RETURN_ID) AS No_Of_Books_Returned,
	SUM(BS.RENTAL_PRICE) AS REVENUE
FROM ISSUED_STATUS AS IST
JOIN EMPLOYEES AS E
ON IST.ISSUED_EMP_ID = E.EMP_ID
JOIN BRANCH AS BR
ON E.BRANCH_ID = BR.BRANCH_ID
LEFT JOIN RETURN_STATUS AS RTS
ON RTS.ISSUED_ID = IST.ISSUED_ID
JOIN BOOKS AS BS
ON BS.ISBN = IST.ISSUED_BOOK_ISBN
GROUP BY 1,2;

SELECT * FROM branch_reports;

```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql
CREATE TABLE Active_Members
AS
SELECT 
	*
FROM MEMBERS
WHERE MEMBER_ID IN (
					SELECT 
						DISTINCT ISSUED_MEMBER_ID
					FROM ISSUED_STATUS
					WHERE  ISSUED_DATE >= CURRENT_DATE - INTERVAL '6 MONTH ');
SELECT * FROM ACTIVE_MEMBERS;

```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT 
	E.EMP_ID,
	E.EMP_NAME,
	COUNT(IST.ISSUED_ID) AS No_Of_Books_Issued,
	E.BRANCH_ID
FROM EMPLOYEES AS E
JOIN ISSUED_STATUS AS IST
ON E.EMP_ID = IST.ISSUED_EMP_ID
GROUP BY 1
ORDER BY 3 DESC
LIMIT 3;
```

**Task 18: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql
CREATE OR REPLACE PROCEDURE Issue_Book(p_iss_id VARCHAR(15), p_iss_mem_id VARCHAR(10), p_iss_book_isbn VARCHAR(25), p_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$
DECLARE
-- DECLARE VARIABLES
	v_status VARCHAR(15);
BEGIN
-- LOGIC
	-- CHECKING IF BOOK IS AVAILABLE:
	SELECT 
		STATUS
		INTO
		v_status
	FROM BOOKS
	WHERE ISBN = p_iss_book_isbn;
	IF v_status = 'yes' THEN
		INSERT INTO ISSUED_STATUS(ISSUED_ID,ISSUED_MEMBER_ID, ISSUED_DATE, ISSUED_BOOK_ISBN, ISSUED_EMP_ID)
		VALUES
		(p_iss_id,p_iss_mem_id, CURRENT_DATE, p_iss_book_isbn,p_emp_id);
		UPDATE BOOKS		
		SET STATUS = 'no'
		WHERE ISBN = p_iss_book_isbn;
		RAISE NOTICE 'Book record added successfully. Book ISBN: %', p_iss_book_isbn;
	ELSE
		RAISE NOTICE 'Sorry to inform you that the book you have requested is currently unavailable';
	END IF;
END;
$$

--  TESTING THE FUNCTION:
SELECT * FROM ISSUED_STATUS
ORDER BY 1;

SELECT * FROM BOOKS
WHERE STATUS = 'no';

SELECT * FROM EMPLOYEES;

-- NEXT IS155, C120, 978-1-60129-456-2, E108
-- ISBN 978-1-60129-456-2 --> YES
-- ISBN 978-0-7432-7357-1  --> NO
CALL Issue_Book('IS155', 'C120','978-1-60129-456-2', 'E108');

CALL Issue_Book('IS156', 'C121','978-0-7432-7357-1', 'E109');

-- CHECKING THE UPDATION FROM YES TO NO
SELECT * 
FROM BOOKS
WHERE ISBN = '978-1-60129-456-2';

```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## How to Use

1. **Clone the Repository**: Clone this repository to your local machine.
   ```sh
   git clone [https://github.com/najirh/Library-System-Management---P2.git
   ```

2. **Set Up the Database**: Execute the SQL scripts in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries in the `analysis_queries.sql` file to perform the analysis.


## Author - Nethikar Sharath

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions or any feedback, feel free to get in touch!

### Stay connected and join me:

- **LinkedIn**: [Connect with me professionally](www.linkedin.com/in/nethikar-sharath-2442a2322)


Thank you , and I look forward to connecting with you!

