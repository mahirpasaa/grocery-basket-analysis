-- Simple behavioural segmentation: order frequency x basket size per customer.
WITH per_order AS (
    SELECT o.user_id, o.order_id, o.days_since_prior_order, COUNT(*) AS items
    FROM orders o
    JOIN order_products op USING (order_id)
    GROUP BY ALL
),
per_user AS (
    SELECT user_id,
           COUNT(*)                     AS n_orders,
           AVG(items)                   AS avg_items,
           AVG(days_since_prior_order)  AS avg_gap_days
    FROM per_order
    GROUP BY user_id
)
SELECT CASE WHEN avg_gap_days <= 7  THEN '1. Weekly'
            WHEN avg_gap_days <= 14 THEN '2. Bi-weekly'
            WHEN avg_gap_days <= 21 THEN '3. Every 3 weeks'
            ELSE                         '4. Monthly+' END     AS frequency_segment,
       CASE WHEN avg_items < 6   THEN 'Small (<6)'
            WHEN avg_items < 12  THEN 'Medium (6-12)'
            ELSE                      'Large (12+)' END        AS basket_segment,
       COUNT(*)                     AS customers,
       ROUND(AVG(n_orders), 1)      AS avg_orders,
       ROUND(SUM(n_orders * avg_items)) AS total_items
FROM per_user
WHERE avg_gap_days IS NOT NULL
GROUP BY ALL
ORDER BY ALL;
