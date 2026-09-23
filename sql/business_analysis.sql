--- TIME ----
-- 1. Peak hour
SELECT *
FROM view_by_hour
ORDER BY orders_count DESC;
-- Findings: Peak hour for delivery is 20 (8 pm) with 2900 orders, while the least – 4 am with 5 total orders. Evening hours 6-23 (6 pm - 11 pm) are quite popular time slots as well. Least hours for delivery are 5 am - 10 am with 0 delivered orders. 

-- 2. Weekday
SELECT order_weekday, COUNT(*) AS orders_count, SUM(total) AS revenue, AVG(CASE WHEN rating IS NOT NULL AND rating != ''
                                                                                THEN rating 
                                                                                END) AS average_rating
FROM view_delivered_orders
GROUP BY order_weekday 
ORDER BY orders_count DESC;
-- Findings: The busiest weekday is Saturday with the biggest number of orders (3888), largest revenue (2751665.88). The least busy weekday is Monday (2182), with the least revenue (1394664.73). Average ratings remain flat during all weekdays (~4.28-4.42).

-- 3. Peak hour and kitchen time
SELECT order_hour, COUNT(*) AS orders_count, AVG(kpt_minutes) AS average_kpt
FROM view_kitchen_time
GROUP BY order_hour
ORDER BY orders_count DESC;
-- Findings: Average kpt for peak hour ( 8 pm ) is 18.38 min and it is not the slowest. The slowest average kpt is 19.49 min at 11 am (301 orders), vs 14.42 at 3 am (374 orders). 

--- RESTAURANTS RELATED ---
-- 4. Kitchen time
SELECT restaurant_name, COUNT(*) AS orders_count, AVG(kpt_minutes) AS average_kpt
FROM view_kitchen_time
GROUP BY restaurant_name
ORDER BY average_kpt DESC;
-- Findings: Aura Pizzas is one of 6 restaurants has the most orders (14293) and second biggest is Swaad (6215). Average kpt is around the same for both (~17-18 min). The slowest restaurant among these 6 is Tandoori Junction – average kpt time is ~21 min with only 149 orders.

-- 5. Revenue
SELECT restaurant_name, SUM(total) AS revenue, COUNT(*) AS orders_count
FROM view_delivered_orders
GROUP BY restaurant_name
ORDER BY revenue DESC;
-- Findings: Aura Pizzas has the most revenue (10647191.66, 14417 orders), then Swaad (3524473.37, 6282). The other 4 restaurants are small (Tandoori 131517 on 151 orders down to Masala 8587 on 26).

--- MONEY ---
-- 6. Discount type
SELECT discount_type, COUNT(*) AS orders_count, SUM(total) AS revenue, AVG(total) AS average_order
FROM view_delivered_orders
GROUP BY discount_type
ORDER BY orders_count DESC;
-- Findings: percent discount type is the most used type of discount for customers (6839) orders, while flat has the highest average order amount(859).

-- 7. How expensive an order is
SELECT CASE 
        WHEN total > 3000 THEN 'over_3000'
        ELSE 'less_or_3000'
        END AS order_size,
        COUNT(*) AS orders_count, SUM(total) AS revenue
FROM view_delivered_orders
GROUP BY order_size;
-- Findings: There are 82 orders that are priced over 3000, and 21049 orders that are priced less or 3000. Almost all volume and revenue are normal bills, not large orders.

--- REVIEWS ---
-- 8. Customer feedback (complaints)
SELECT customer_complaint_tag, COUNT(*) AS orders_count 
FROM view_delivered_orders
GROUP BY customer_complaint_tag
ORDER BY orders_count DESC;
-- Findings: 20662 had no complaints(most orders do not have complaints). The most popular complaint is non-refunded(157) and poor taste or quality (120), poor packaging or spillage(104). 

-- 9. Rating and kitchen time
SELECT rating, COUNT(*) AS orders_count, AVG(kpt_minutes) AS average_kpt
FROM view_rated_orders
WHERE kpt_minutes IS NOT NULL AND kpt_minutes != ''
GROUP BY rating
ORDER BY rating;
-- Findings: kpt does not show a link with the customer rating – 1.0 rating has average kpt ~17.40, while 5.0 rating has 17.74 average kpt. 

