-- Share of order lines, order penetration and loyalty (reorder rate) per department.
WITH totals AS (
    SELECT COUNT(*) AS lines, COUNT(DISTINCT order_id) AS orders FROM order_lines
)
SELECT department,
       COUNT(*)                                            AS lines,
       ROUND(COUNT(*) * 100.0 / ANY_VALUE(t.lines), 2)     AS line_share_pct,
       ROUND(COUNT(DISTINCT order_id) * 100.0 / ANY_VALUE(t.orders), 1) AS order_penetration_pct,
       ROUND(AVG(reordered) * 100, 1)                      AS reorder_rate_pct
FROM order_lines, totals t
GROUP BY department
ORDER BY lines DESC;
