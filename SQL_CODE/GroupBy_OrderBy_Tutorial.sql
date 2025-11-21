SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
group by gender
;

SELECT occupation, salary
FROM employee_salary
group by occupation, salary
;

-- ORDER BY
SELECT *
FROM employee_demographics
ORDER BY first_name ASC
;

SELECT *
FROM employee_demographics
ORDER BY gender, age DESC
;

SELECT * -- Poti si cu pozitiile de la coloane WTF
FROM employee_demographics
ORDER BY 5, 4
;