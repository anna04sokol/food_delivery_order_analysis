-- Delivered orders
DROP VIEW IF EXISTS view_delivered_orders;

CREATE VIEW view_delivered_orders AS
SELECT * 
FROM orders
WHERE order_status = 'Delivered';

-- Rated orders
DROP VIEW IF EXISTS view_rated_orders;

CREATE VIEW view_rated_orders AS
SELECT * 
FROM orders
WHERE order_status = 'Delivered' AND rating IS NOT NULL AND rating != ''; -- '' is when null values become '' in CSV  

-- Kitchen time exists
DROP VIEW IF EXISTS view_kitchen_time;

CREATE VIEW view_kitchen_time AS 
SELECT * 
FROM orders
WHERE order_status = 'Delivered' AND kpt_minutes IS NOT NULL AND kpt_minutes != '';

-- Rider wait time exists
DROP VIEW IF EXISTS view_rider_wait_time;

CREATE VIEW view_rider_wait_time AS
SELECT *
FROM orders
WHERE order_status = 'Delivered' AND rider_wait_minutes IS NOT NULL AND rider_wait_minutes != '';

-- Group by hour
DROP VIEW IF EXISTS view_by_hour;

CREATE VIEW view_by_hour AS
SELECT order_hour, COUNT(*) AS orders_count, SUM(total) AS revenue, AVG (CASE WHEN rating IS NOT NULL AND rating != ''
                                                                                THEN rating 
                                                                                END) AS average_rating
FROM orders
WHERE order_status = 'Delivered'
GROUP BY order_hour;