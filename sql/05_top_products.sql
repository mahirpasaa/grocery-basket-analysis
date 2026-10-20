-- Top 20 products by order count, with reorder rate and how early they go into the cart.
SELECT product_name,
       department,
       COUNT(*)                         AS orders,
       ROUND(AVG(reordered) * 100, 1)   AS reorder_rate_pct,
       ROUND(AVG(add_to_cart_order), 1) AS avg_cart_position
FROM order_lines
GROUP BY product_name, department
ORDER BY orders DESC
LIMIT 20;
