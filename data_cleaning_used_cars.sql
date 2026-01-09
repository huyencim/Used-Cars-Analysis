-- Create database
CREATE DATABASE used_car_analysis;
USE used_car_analysis;

-- import CSV file to MySQL

-- Data cleaning
select * 
from used_cars;

-- step 1: remove duplicates if any
-- step 2: standardize the data
-- step 3: null values or blank values
-- step 4: remove any columns or rows

create table used_cars_staging
like used_cars;

select *
from used_cars_staging;

insert used_cars_staging
select * 
from used_cars;

-- step 1: remove duplicates if any

select *,
row_number() over(
partition by brand, model, model_year, milage) as row_num
from used_cars_staging;

with duplicate_cte as 
(
select *,
row_number() over(
partition by brand, model, model_year, milage) as row_num
from used_cars_staging
)
select *
from duplicate_cte
where row_num > 1;

CREATE TABLE `used_cars_staging2` (
  `brand` text,
  `model` text,
  `model_year` int DEFAULT NULL,
  `milage` text,
  `fuel_type` text,
  `engine` text,
  `transmission` text,
  `ext_col` text,
  `int_col` text,
  `accident` text,
  `clean_title` text,
  `price` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from used_cars_staging2;

insert into used_cars_staging2
select brand, model, model_year, milage, fuel_type, engine, transmission,
       ext_col, int_col, accident, clean_title, price
from used_cars_staging;

ALTER TABLE used_cars_staging2 ADD COLUMN row_num INT;

UPDATE used_cars_staging2 u
JOIN (
    SELECT brand, model, model_year, milage,
           ROW_NUMBER() OVER (PARTITION BY brand, model, model_year, milage ORDER BY brand) AS rn
    FROM used_cars_staging2
) t
ON u.brand = t.brand AND u.model = t.model AND u.model_year = t.model_year AND u.milage = t.milage
SET u.row_num = t.rn;

select *
from used_cars_staging2
where row_num>1;

delete 
from used_cars_staging2
where row_num > 1;


-- step 2: standardize the data
select *
from used_cars_staging2;

-- clean 'milage'
-- remove 'mi'
UPDATE used_cars_staging2
SET milage = REPLACE(milage, ' mi', '');

-- remove commas
UPDATE used_cars_staging2
SET milage = REPLACE(milage, '.', '');

-- add column milage_int to change milage to INT
ALTER TABLE used_cars_staging2 ADD COLUMN milage_int INT;
UPDATE used_cars_staging2
SET milage_int = CAST(milage AS UNSIGNED);

-- drop column milage
ALTER TABLE used_cars_staging2
DROP COLUMN milage;

ALTER TABLE used_cars_staging2
CHANGE COLUMN milage_int milage INT;

-- clean 'price'
-- remove '$'
UPDATE used_cars_staging2
SET price = REPLACE(price, '$', '');

-- remove commas
UPDATE used_cars_staging2
SET price = REPLACE(price, ',', '');

-- add column price_int to change price to INT
ALTER TABLE used_cars_staging2 ADD COLUMN price_int INT;
UPDATE used_cars_staging2
SET price_int = CAST(price AS UNSIGNED);

-- drop column price
ALTER TABLE used_cars_staging2
DROP COLUMN price;

ALTER TABLE used_cars_staging2
CHANGE COLUMN price_int price INT;

-- step 3: check for null values or blank values
select *
from used_cars_staging2;

SELECT 
    COUNT(*) AS total_rows,
    SUM(milage IS NULL OR milage = 0) AS missing_milage,
    SUM(price IS NULL OR price = 0) AS missing_price,
    SUM(model_year IS NULL OR model_year = 0) AS missing_model_year
FROM used_cars_staging2;

SELECT 
    COUNT(*) AS total_rows,
    SUM(brand IS NULL OR TRIM(brand) = '') AS missing_brand,
    SUM(model IS NULL OR TRIM(model) = '') AS missing_model,
    SUM(fuel_type IS NULL OR TRIM(fuel_type) = '') AS missing_fuel_type
FROM used_cars_staging2;

-- step 4: remove any columns or rows
-- drop column row_num 
ALTER TABLE used_cars_staging2
DROP COLUMN row_num;



