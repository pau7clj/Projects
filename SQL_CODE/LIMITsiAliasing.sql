SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 3
; -- Primii 3 cei mai batrani employees


SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1
; -- Ia primu de dupa primii 2


-- Aliasing
SELECT gender, AVG(age)
FROM employee_demographics
Group by gender
HAVING AVG(age) > 40
;
-- Acelasi lucru cu
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
Group by gender
HAVING avg_age > 40
;
-- AS nu e neaparat de pus ca se subintelege
SELECT gender, AVG(age) avg_age
FROM employee_demographics
Group by gender
HAVING avg_age > 40
;