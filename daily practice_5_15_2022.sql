## Indexes ##
# how many people have been hired after the 1st of Jan 2000?
SELECT *
FROM employees
WHERE hire_date > '2000-01-01';

CREATE INDEX i_hire_date ON employees(hire_date);

## Composite Index
# SELECT all empoyees bearing the name "George Facello"
SELECT *
FROM employees
WHERE first_name = 'Georgi' AND last_name = 'Facello';

CREATE INDEX i_composite ON employees(first_name,last_name);

SHOW INDEX FROM employees FROM employees;

# Exercise 1
# Drop the 'i_hire_date' index

ALTER TABLE employees
DROP INDEX i_hire_date;

# Select all records from the 'salaries' table of people whose salary is higher than $89k
# Then create an index on the 'salary' column of that table, and check if it sped up the search
SELECT *
FROM salaries
WHERE salary > '89000';

CREATE INDEX i_salary ON salaries (salary);

# CASE Statement
# If 'M' then return male, if 'F' them return female
SELECT emp_no, first_name, last_name,
CASE
	WHEN gender = 'M' THEN 'Male'
	ELSE 'Female'
END AS gender
FROM employees;

SELECT emp_no, first_name, last_name,
	IF(gender = 'M', 'Male', 'Female') AS gender
    FROM employees;

SELECT 
	dm.emp_no, 
		e.first_name,
		e.last_name,
        MAX(s.salary)-MIN(s.salary) AS salary_difference,
        CASE
			WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
            WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN
										'Salary was raised by more than $20,000 but less than $30,000'
			ELSE 'Salary was raised by less than $20,000'
		END AS salary_increase
FROM dept_manager dm
		JOIN
	employees e ON e.emp_no = dm.emp_no
		JOIN
	salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;

# Similar to the exercises done in the lecture, obtain a result set 
# containing the employee number, first name, and last name of all employees with a number higher than 109990. 
# Create a fourth column in the query, indicating whether this employee is also a manager, according to the data 
# provided in the dept_manager table, or a regular employee.
SELECT e.emp_no, e.first_name, e.last_name,
CASE 
	WHEN dm.emp_no IS NOT NULL THEN 'Manager'
    ELSE 'Employee'
END AS is_manager
FROM employees e
	LEFT JOIN
    dept_manager dm ON dm.emp_no = e.emp_no
WHERE e.emp_no > 109990;

# Extract a dataset containing the following information about the 
# managers: employee number, first name, and last name. Add two columns at the end – 
# one showing the difference between the maximum and minimum salary of that employee, 
# and another one saying whether this salary raise was higher than $30,000 or NOT.
SELECT 
		dm.emp_no, 
		e.first_name,
		e.last_name,
        MAX(s.salary)-MIN(s.salary) AS salary_difference,
        CASE
			WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
            ELSE 'Salary was NOT raised by more then $30,000'
		END AS salary_raised
FROM dept_manager dm
	JOIN
    employees e ON e.emp_no = dm.emp_no
    JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;

# Extract the employee number, first name, and last name of the first 100 employees, 
# and add a fourth column, called “current_employee” saying “Is still employed” 
# if the employee is still working in the company, or “Not an employee anymore” if they aren’t.
SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS current_employee
FROM
    employees e
        JOIN
    dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no
LIMIT 100;
