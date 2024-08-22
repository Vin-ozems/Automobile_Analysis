/* DATA CLEANING OF AUTOMOBILE_DATA */
SELECT *
FROM automobile_data;
-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- RENAMING COLOUMN
ALTER TABLE automobile_data
CHANGE COLUMN `normalized-losses` `normalized_losses` INT;

ALTER  TABLE automobile_data
CHANGE COLUMN `fuel-type` `fuel_type` TEXT;

ALTER TABLE automobile_data
CHANGE COLUMN `num-of-doors` `num_of_doors` TEXT;

ALTER TABLE automobile_data
CHANGE COLUMN `body-style` `body_style` TEXT;

ALTER TABLE automobile_data
CHANGE COLUMN `drive-wheels` `drive_wheels` TEXT;

ALTER TABLE automobile_data
CHANGE COLUMN `engine-location` `engine_location` TEXT;

ALTER TABLE automobile_data
CHANGE COLUMN `wheel-base` `wheel_base` INT;

ALTER TABLE automobile_data
CHANGE COLUMN `curb-weight` `curb_weight` INT;

ALTER TABLE automobile_data
CHANGE COLUMN `engine-type` `engine_type` TEXT;

ALTER TABLE automobile_data
CHANGE COLUMN `num-of-cylinders` `num_of_cylinders` TEXT;

ALTER TABLE automobile_data
CHANGE COLUMN `engine-size` `engine_size` INT;

ALTER TABLE automobile_data
CHANGE COLUMN `fuel-system` `fuel_system` TEXT;

ALTER TABLE automobile_data
CHANGE COLUMN `compression-ratio` `compression_ratio` INT;

ALTER TABLE automobile_data
CHANGE COLUMN `peak-rpm` `peak_rpm` INT;

ALTER TABLE automobile_data
CHANGE COLUMN `city-mpg` `city_mpg` INT;

ALTER TABLE automobile_data
CHANGE COLUMN `highway-mpg` `highway_mpg` INT;

-- --------------------------------------------------------------------------------------------------------------------------------------------------
-- FEATURE ENGINEERING
SELECT *
FROM automobile_data;

SELECT 
    drive_wheels,
    CASE
        WHEN drive_wheels = 'rwd' THEN 'rear wheel drive'
        WHEN drive_wheels = 'fwd' THEN 'front wheel drive'
        ELSE '4 wheel drive'
    END AS drive_wheels
FROM automobile_data;

UPDATE automobile_data 
SET 
    drive_wheels = (CASE
        WHEN drive_wheels = 'rwd' THEN 'rear wheel drive'
        WHEN drive_wheels = 'fwd' THEN 'front wheel drive'
        ELSE '4 wheel drive'
    END);
    
SELECT 
    num_of_doors,
    (CASE
        WHEN num_of_doors = 'two' THEN 2
        ELSE 4
    END) num_of_doors
FROM automobile_data;

UPDATE automobile_data 
SET num_of_doors = (CASE
        WHEN num_of_doors = 'two' THEN 2
        ELSE 4
    END);
-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- DROPPING COLUMN
ALTER TABLE automobile_data
DROP COLUMN symboling,
DROP COLUMN normalized_losses,
DROP COLUMN bore, 
DROP COLUMN stroke;

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- EDA
-- What is the distribution of cars based on fuel type in the dataset?
SELECT fuel_type, COUNT(*)
FROM automobile_data
GROUP BY fuel_type;

-- How does the average curb weight vary across different body styles?
SELECT ROUND(AVG(curb_weight)) avg_curb_weight, 
       body_style
FROM automobile_data
GROUP BY body_style;

-- What is the most common aspiration type among the cars?
SELECT aspiration,
	   COUNT(*)
FROM automobile_data
GROUP BY aspiration
ORDER BY 1 DESC;

-- Are there any noticeable trends between engine size and horsepower?
SELECT engine_size, 
       AVG(horsepower)
FROM automobile_data
GROUP BY engine_size;

-- How does the average price differ for cars with different fuel systems?
SELECT AVG(price),
       COUNT(*), fuel_system
FROM automobile_data
GROUP BY fuel_system;

SELECT make, 
       body_style, 
       city_mpg, 
       highway_mpg
FROM automobile_data
ORDER BY city_mpg DESC , highway_mpg DESC
LIMIT 5;

-- Is there a relationship between engine location and horsepower?
SELECT engine_location, 
       AVG(horsepower) as avg_horsepower
FROM automobile_data
GROUP BY engine_location;

-- How does the distribution of prices vary for different drive wheel types?
SELECT drive_wheels,
       MIN(price) AS min_price,
       MAX(price) AS max_price,
       AVG(price) AS avg_price
FROM automobile_data
GROUP BY drive_wheels;

-- Identify cars with the best fuel efficiency, considering a combination of city and highway mpg.
SELECT make, 
       (city_mpg + highway_mpg) AS combined_mpg
FROM automobile_data
ORDER BY combined_mpg DESC
LIMIT 5;

-- Find the make and model of the most expensive car in each body style.
WITH RankedCars AS (
                    SELECT make, price, body_style,
					ROW_NUMBER() OVER (PARTITION BY body_style ORDER BY price DESC) as row_nu 
					FROM automobile_data
)
SELECT make, price, body_style
FROM RankedCars
WHERE row_nu = 1
limit 5;

-- Identify the body style with the highest average price for cars with rear engine placement.
SELECT body_style, 
       AVG(price) AS avg_price
FROM automobile_data
WHERE engine_location = 'rear'
GROUP BY body_style
ORDER BY avg_price DESC
LIMIT 1;

-- Identify the drive wheel type with the most significant difference in average price between gas and diesel-fueled cars.
SELECT drive_wheels, fuel_type, 
       AVG(price) AS avg_price
FROM automobile_data
GROUP BY drive_wheels , fuel_type
