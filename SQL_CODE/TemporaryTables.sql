-- Temporary Tables
-- exista in memorie cat timp esti in aplicatie sa zicem si l poti folosi ca ajutor pt a stoca date intermediare pana creezi un tabel adevarat

-- Prima varianta
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

INSERT INTO temp_table
VALUES('Paul', 'Batin', "Predestination");

SELECT *
FROM temp_table;

-- A doua varianta (mai buna)
SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;