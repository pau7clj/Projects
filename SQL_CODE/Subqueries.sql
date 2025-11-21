-- Subqueries

SELECT *
FROM employee_demographics
WHERE employee_id IN (
	SELECT employee_id
    FROM employee_salary
    WHERE dept_id = 1
)
;

SELECT first_name, salary, 
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary
;

-- helper shitter
SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender
;

SELECT AVG(`MAX(age)`) -- pui asta ca asta i numele tabelului creat in FROM, nu i string shitter
FROM 
(SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender) AS Agg_table
;
-- sau
SELECT AVG(max_age)
FROM 
(SELECT gender,
AVG(age) AS avg_age, 
MAX(age) AS max_age, 
MIN(age) AS min_age, 
COUNT(age) AS count_age
FROM employee_demographics
GROUP BY gender) AS Agg_table
;