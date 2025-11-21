-- String Functions

SELECT LENGTH('skyfall');

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;


SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

-- TRIM
# Daca folosesti RTRIM sau LTRIM iti elimina white space-urile din partea dortia (right/left)
SELECT TRIM('                       sky           ');

SELECT first_name,
LEFT(first_name, 4), -- Ia primele 3 caractere de la stanga 
RIGHT(first_name, 4), -- Ia primele 3 caractere de la dreapta
SUBSTRING(first_name, 3, 2), -- De la pozitia 3 din string ia 2 caractere
birth_date,
SUBSTRING(birth_date, 6, 2) AS birth_month
FROM employee_demographics;


-- Replace
SELECT first_name, REPLACE(first_name, 'a', 'z')
FROM employee_demographics;

SELECT LOCATE('x', 'Alexander'); -- Gaseste pozitia la care gaseste x in Alexander
SELECT first_name, LOCATE('An', first_name)
FROM employee_demographics;


SELECT first_name, last_name,
CONCAT(first_name, ' ', last_name, '+') AS full_name -- Concateneaza numele si baga si patiu si + dupa
FROM employee_demographics;