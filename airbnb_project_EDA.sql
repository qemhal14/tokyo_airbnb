-- Tokyo Airbnb 2023 Exploratory Data Analysist -- 
-- DATA CLEANING

SELECT * 
FROM [dbo].[listings]; -- 10154 rows

-- Duplicates value has been deleted in excel prior to importing data to SQL

SELECT *
FROM listings
WHERE id IS NULL; -- 27 values in id column is NULL

DELETE FROM listings
WHERE id IS NULL;

SELECT *
FROM listings
WHERE host_id IS NULL; -- 26 values NULL

DELETE FROM listings
WHERE host_id IS NULL;
-- 53 rows deleted, 10101 rows remain

SELECT * 
FROM [dbo].[listings];

-- Converting datetime format from last_review column to date only because time only showing 00:00:00
ALTER TABLE listings
ALTER COLUMN last_review DATE;

-- Doing more checking on the data

SELECT id, host_id, host_name, neighbourhood
FROM listings
ORDER BY neighbourhood DESC;

SELECT latitude, longitude
FROM listings
WHERE latitude IS NULL  
AND longitude IS NULL;

SELECT	room_type,
		COUNT(room_type) AS Count_type
FROM listings
GROUP BY room_type;

SELECT last_review
FROM listings
ORDER BY last_review ASC;

-- EXPLORING DATA

SELECT *
FROM listings;

SELECT COUNT(*)
FROM listings; -- 10101 airbnb listings in Tokyo

-- Number of listings per area

SELECT	neighbourhood,
		COUNT(*) AS num_of_listing
FROM listings
GROUP BY neighbourhood
ORDER BY 2 DESC;

-- Most listed type of room in Tokyo

SELECT	room_type,
	COUNT(room_type) AS room_type_count,
	COUNT(room_type) * 100 / SUM(COUNT(room_type)) OVER() AS percentage_room
FROM listings
GROUP BY room_type
ORDER BY room_type_count DESC;

-- average price based on room types, area
-- room type

SELECT	room_type,
		AVG(price) AS avg_price_night
FROM listings
GROUP BY room_type;

-- area 

SELECT	neighbourhood,
		AVG(price) AS avg_price_night
FROM listings
GROUP BY neighbourhood
ORDER BY 2 DESC;

SELECT	neighbourhood,
		MAX(price) AS max_price_night
FROM listings
GROUP BY neighbourhood;

SELECT	neighbourhood,
		MIN(price) AS min_price_night
FROM listings
WHERE price > 0
GROUP BY neighbourhood;

-- Top 50 Cheapest listing with review more than 50

SELECT TOP 50
	name, 
	host_name,
	neighbourhood,
	room_type,
	minimum_nights,
	price,
	number_of_reviews
FROM listings
WHERE number_of_reviews > 50
AND price > 0 
ORDER BY price ASC;

-- Ratio between short term and long term listings

SELECT
    (COUNT(CASE WHEN minimum_nights <= 10 THEN 1 END) * 100.0 / COUNT(minimum_nights)) AS short_term_percentage,
    (COUNT(CASE WHEN minimum_nights > 10 THEN 1 END) * 100.0 / COUNT(minimum_nights)) AS long_term_percentage
FROM listings;

SELECT *
FROM listings;

-- Total Host and top host with the most listings

SELECT 
	COUNT(DISTINCT host_name) AS total_host
FROM listings

SELECT
	DISTINCT host_name,
	calculated_host_listings_count
FROM listings
ORDER BY 2 DESC

-- Listings per host ratio

SELECT
    (COUNT(CASE WHEN calculated_host_listings_count = 1 THEN 1 END) * 100.0 / COUNT(calculated_host_listings_count)) AS single_listings,
    (COUNT(CASE WHEN calculated_host_listings_count > 1 THEN 1 END) * 100.0 / COUNT(calculated_host_listings_count)) AS multi_listings
FROM listings;