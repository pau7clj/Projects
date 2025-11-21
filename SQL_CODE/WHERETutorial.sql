SELECT *
FROM employee_salary
WHERE first_name = 'Leslie'
;

SELECT *
FROM employee_salary
WHERE salary >= 50000
;

SELECT *
FROM employee_demographics
WHERE gender = 'Male' AND NOT birth_date > '1985-01-01'
;

SELECT *
FROM employee_demographics
WHERE first_name LIKE '%er%'
;

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a__%'
;

SELECT *
FROM employee_demographics
WHERE birth_date LIKE '1988%'
;