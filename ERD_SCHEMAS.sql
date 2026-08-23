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


-- FOREIGN KEY's:

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES MEMBERS(member_id);

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_books_isbn
FOREIGN KEY (issued_book_isbn)
REFERENCES BOOKS(isbn);

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_emp_id
FOREIGN KEY (issued_emp_id)
REFERENCES EMPLOYEES(emp_id);

ALTER TABLE EMPLOYEES
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES BRANCH(branch_id);

ALTER TABLE RETURN_STATUS
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES ISSUED_STATUS(issued_id);


-- Building ERD(i.e ER- Diagram) for our tables.
	-- Right-Click on the Database and select "ERD for Database"