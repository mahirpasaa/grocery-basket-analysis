-- How many days pass between a customer's consecutive orders?
-- Instacart caps the value at 30, so "30" means "30 or more".
SELECT CAST(days_since_prior_order AS INTEGER) AS days_since_prior,
       COUNT(*)                                AS orders,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM orders
WHERE days_since_prior_order IS NOT NULL
GROUP BY 1
ORDER BY 1;
