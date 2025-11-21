-- HAVING vs WHERE
SELECT gender, AVG(age)
FROM employee_demographics
WHERE AVG(age) > 40 -- Nu poti cu functii agregate ca AVG(age) se intampla numa dupa ce se grupeaza dupa gender si nu i bine
GROUP BY gender; 

SELECT gender, AVG(age)
FROM employee_demographics 
GROUP BY gender
HAVING AVG(age) > 40  -- Asa se poate
; 

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'  -- ROW lvl filtering
GROUP BY occupation
HAVING AVG(salary) > 55000 -- Agregate function filtering
;