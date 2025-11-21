-- Unions
SELECT first_name, last_name
FROM employee_demographics
UNION -- asta i UNION DISTINCT si nu mai ai duplicate
SELECT first_name, last_name
FROM employee_salary
;

SELECT first_name, last_name
FROM employee_demographics
UNION ALL -- asta i UNION care baga duplicate
SELECT first_name, last_name
FROM employee_salary
;

SELECT first_name, last_name, 'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'HighlyPaid' AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;