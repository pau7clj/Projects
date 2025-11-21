-- Case Statements

SELECT  first_name,
last_name,
age,
CASE
	WHEN age < 30 THEN 'Young'
    WHEN age BETWEEN 32 AND 50 THEN 'Old'
    WHEN age >= 50 THEN 'DAMN'
END AS age_bracket
FROM employee_demographics;

-- PROBLEMA:
-- Pay Increase Bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10%
SELECT first_name,
last_name,
salary,
CASE
	WHEN salary < 50000 THEN salary + salary * 5/100
    WHEN salary > 50000 THEN salary + salary * 7/100
END AS increased_salary, 
CASE
	WHEN dept_id = 6 THEN salary + salary * 1/10
END AS bonus
FROM employee_salary;

-- helping shit
SELECT *
FROM employee_salary;
SELECT * 
FROM parks_departments;