-- Stored Procedures
-- practic functii
SELECT *
FROM employee_salary
WHERE salary >= 50000;

USE parks_and_recreation;
CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

-- Nu merge asa ca avem delimiteru ; si se stocheaza numa primu select si al doilea se apeleaza separat
CREATE PROCEDURE large_salaries2()
SELECT *
FROM employee_salary
WHERE salary >= 50000;
SELECT *
FROM employee_salary
WHERE salary >= 10000;
-- Asa ca facem schema si schimbam delimiteru (il si schimbam inapoi dupa ca nu suntem creizi)
DELIMITER $$
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;

CALL large_salaries3();

-- Sau mergi la stored procedures si dai click dreapta si creezi una si o faci manual

-- Acuma bagam parametrii ca la functii
DELIMITER $$
CREATE PROCEDURE large_salaries4(p_employee_id INT)
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = p_employee_id;
END $$
DELIMITER ;

CALL large_salaries4(1);