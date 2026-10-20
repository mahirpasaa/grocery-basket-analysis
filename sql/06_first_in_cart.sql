-- Which aisles do shoppers go to first? Share of baskets that START with each aisle,
-- compared with the aisle's overall share of lines ("first-in-cart index").
WITH first_item AS (
    SELECT aisle, COUNT(*) AS first_count
    FROM order_lines
    WHERE add_to_cart_order = 1
    GROUP BY aisle
),
all_items AS (
    SELECT aisle, COUNT(*) AS line_count
    FROM order_lines
    GROUP BY aisle
)
SELECT f.aisle,
       ROUND(f.first_count * 100.0 / SUM(f.first_count) OVER (), 2) AS first_in_cart_pct,
       ROUND(a.line_count  * 100.0 / SUM(a.line_count)  OVER (), 2) AS line_share_pct,
       ROUND((f.first_count * 1.0 / SUM(f.first_count) OVER ())
           / (a.line_count  * 1.0 / SUM(a.line_count)  OVER ()), 2) AS first_in_cart_index
FROM first_item f
JOIN all_items a USING (aisle)
QUALIFY line_share_pct >= 0.5
ORDER BY first_in_cart_index DESC;
