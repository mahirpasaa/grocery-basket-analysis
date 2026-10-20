-- Headline KPIs for the whole dataset.
WITH basket AS (
    SELECT order_id,
           COUNT(*)      AS items,
           AVG(reordered) AS reorder_share
    FROM order_products
    GROUP BY order_id
)
SELECT (SELECT COUNT(*)                 FROM orders)          AS orders,
       (SELECT COUNT(DISTINCT user_id)  FROM orders)          AS customers,
       (SELECT COUNT(DISTINCT product_id) FROM order_products) AS products_sold,
       (SELECT COUNT(*)                 FROM order_products)  AS order_lines,
       ROUND(AVG(items), 2)                                   AS avg_basket_size,
       ROUND(MEDIAN(items), 0)                                AS median_basket_size,
       ROUND((SELECT AVG(reordered) FROM order_products) * 100, 1) AS reorder_rate_pct
FROM basket;
