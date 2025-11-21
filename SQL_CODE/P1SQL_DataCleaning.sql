-- Proiect1: Data cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns that is not relevant

-- facem asta ca sa avem un tabel de raw data si unul bun ca asa se face irl (un fel de backup)
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

SELECT *
FROM layoffs_staging;

-- toate o sa aiba 1, dar daca e vreunul >=2 inseamna ca avem duplicates
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num -- faci dupa toate coloanele
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
-- dam un check repede sa vedem daca e chiar asa
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- cream un tabel nou care sa aiba si row num din care sa stergem ce nu avem nevoie pt ca in cte nu poti direct
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- inseram query-ul anterior in tabelu asta staging 2
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num -- faci dupa toate coloanele
FROM layoffs_staging;
-- am sters duplicatele ca daca row nr ii mai mare decat 1 inseamna ca o mai fost inca o data chestia aia in tabel
DELETE
FROM layoffs_staging2
WHERE row_num > 1;
-- acuma observam ca coloana row_num nu mai e necesara
SELECT *
FROM layoffs_staging2;

-- Standardizing data
-- avem spatii aiurea pe care vrem sa le eliminam din numele companiilor
SELECT company, TRIM(company)
FROM layoffs_staging2;
-- bagam si update direct si am mai rezolvat o treaba
UPDATE layoffs_staging2
SET company = TRIM(company);

-- acuma vedem la industry niste probleme posibile: avem empty sau null si avem de exemplu Crypto/CryptoCurency/Crypto Currency care ar trebui sa fie toate acelasi lucru
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- mai bagam o vizualizare pt treaba cu crypto
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';
-- dam update
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- boom, mai verificam o data 
SELECT DISTINCT industry
FROM layoffs_staging2;
-- perfect
-- acm te uiti la fiecare in parte si daca ii ceva bai il rezolvi
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;
-- vedem ca avem si United States si United States.
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) -- alt trick, iti trimuie punctu de la final daca folosesti asa cu 'TRAILING'
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country =  TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';
-- boom, gata si asta
-- acuma vedem ca date e text din ceva motive si asta e rau
SELECT `date`
FROM layoffs_staging2;
-- folosim STR_TO_DATE(column, format)  care formatu ii de la data initiala si transforma in date conventional
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;
-- acm dam update
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
-- boom + verificare
SELECT *
FROM layoffs_staging2;
-- totusi vedem ca data type-ul din tabel e inca text, dar cum am schimbat deja formatu, putem schimba si data type ul din tabel. Inainte ar fi dat eroare, textul nefiind in format corect
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
-- boom

-- NULLS si BLANK
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL; -- nu merge cu =

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; -- no astea is useless pt noi, poate le am putea sterge de tot

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';
-- verificam daca exista datele undeva ca sa putem popula noi chestiile goale
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';
-- de ex dintre companiile cu industry gol, vedem ca Airbnb are industry Travel in alt entry, deci putem popula industryu

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND (t2.industry IS NOT NULL AND t2.industry != '');
-- traducem asta intr-un UPDATE
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND (t2.industry IS NOT NULL AND t2.industry != '');
-- boom, ramane doar Bally's Interactive care ii singuru cu numele asta si are null null
SELECT *
FROM layoffs_staging2;
-- acuma ramane sa removeuim datele de care n avem nevoie
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- e ify dar nu o sa avem nevoie de datele astea mai incolo avand in vedere ca vrem sa ne folosim de total laid off si de percentage laid off
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;
-- nu ne mai trebe row_num ca am terminat cu el
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
