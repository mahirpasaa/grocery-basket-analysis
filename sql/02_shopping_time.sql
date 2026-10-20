-- Order volume by day of week x hour of day (staffing / delivery-slot planning).
-- order_dow is not documented by Instacart; 0/1 are commonly read as Saturday/Sunday
-- because they are the two busiest days.
SELECT order_dow,
       order_hour_of_day,
       COUNT(*) AS orders
FROM orders
GROUP BY ALL
ORDER BY order_dow, order_hour_of_day;
