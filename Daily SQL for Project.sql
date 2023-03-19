## 5/14/2022 ##

SELECT first_name, COUNT(first_name) AS 'First Name Count'
FROM employees
GROUP BY first_name
HAVING COUNT(first_name) > 250
ORDER BY first_name DESC;

SELECT *
FROM employees
WHERE hire_date LIKE('%2000%');

SELECT *
FROM employees
WHERE emp_no LIKE('1000_');

SELECT *
FROM salaries
WHERE salary > '150000';

SELECT *
FROM salaries
WHERE emp_no NOT BETWEEN '10004' AND '10012';

SELECT *
FROM departments
WHERE dept_no BETWEEN 'd003' AND 'd006';
