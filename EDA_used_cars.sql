-- Exploratory Data Analysis

-- STEP 1: Dataset Overview

-- Total number of cars
SELECT COUNT(*) AS total_cars
FROM used_cars_staging2;

-- Price stats
SELECT MIN(price) AS min_price,
       MAX(price) AS max_price,
       ROUND(AVG(price),0) AS avg_price
FROM used_cars_staging2;

-- Milage stats
SELECT MIN(milage) AS min_milage,
       MAX(milage) AS max_milage,
       ROUND(AVG(milage),0) AS avg_milage
FROM used_cars_staging2;

-- Model year stats
SELECT MIN(model_year) AS oldest,
       MAX(model_year) AS newest
FROM used_cars_staging2;

-- STEP 2: Categorical Column Distributions

-- Cars per brand
SELECT brand, COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY brand
ORDER BY total_cars DESC;

-- Cars per fuel type
SELECT fuel_type, COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY fuel_type;

-- Cars per transmission
SELECT transmission, COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY transmission;

-- Accident history
SELECT accident, COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY accident;

-- Clean title
SELECT clean_title, COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY clean_title;

-- STEP 3: Price vs Milage

SELECT
  CASE
    WHEN milage < 30000 THEN 'Low'
    WHEN milage BETWEEN 30000 AND 80000 THEN 'Medium'
    ELSE 'High'
  END AS milage_group,
  ROUND(AVG(price),0) AS avg_price,
  COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY milage_group;

-- STEP 4: Price vs Model Year

SELECT model_year,
       ROUND(AVG(price),0) AS avg_price,
       COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY model_year
ORDER BY model_year;

-- STEP 5: Price vs Transmission

SELECT transmission,
       ROUND(AVG(price),0) AS avg_price,
       COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY transmission;

-- STEP 6: Price vs Accident / Clean Title

-- Accident
SELECT accident,
       ROUND(AVG(price),0) AS avg_price,
       COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY accident;

-- Clean title
SELECT clean_title,
       ROUND(AVG(price),0) AS avg_price,
       COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY clean_title;

-- STEP 7: Multi-Factor Analysis

-- Brand + Milage
SELECT brand,
  CASE
    WHEN milage < 30000 THEN 'Low'
    WHEN milage BETWEEN 30000 AND 80000 THEN 'Medium'
    ELSE 'High'
  END AS milage_group,
  ROUND(AVG(price),0) AS avg_price,
  COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY brand, milage_group
ORDER BY brand, milage_group;

-- Transmission + Fuel Type
SELECT transmission,
       fuel_type,
       ROUND(AVG(price),0) AS avg_price,
       COUNT(*) AS total_cars
FROM used_cars_staging2
GROUP BY transmission, fuel_type;

