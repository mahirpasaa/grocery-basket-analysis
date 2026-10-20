-- Market basket analysis in pure SQL: support, confidence and lift for product pairs.
-- Restricted to the {top_n} most-ordered products to keep the self-join tractable
-- (these products still cover the large majority of all order lines).
WITH n_orders AS (
    SELECT COUNT(DISTINCT order_id) AS n FROM order_products
),
top_products AS (
    SELECT product_id, COUNT(*) AS cnt
    FROM order_products
    GROUP BY product_id
    ORDER BY cnt DESC
    LIMIT {top_n}
),
lines AS (
    SELECT op.order_id, op.product_id
    FROM order_products op
    JOIN top_products USING (product_id)
),
pairs AS (
    SELECT a.product_id AS product_a,
           b.product_id AS product_b,
           COUNT(*)     AS pair_orders
    FROM lines a
    JOIN lines b
      ON a.order_id = b.order_id
     AND a.product_id < b.product_id
    GROUP BY 1, 2
    HAVING COUNT(*) >= {min_pair_orders}
)
SELECT pa.product_name                                   AS product_a,
       pb.product_name                                   AS product_b,
       aa.aisle                                          AS aisle_a,
       ab.aisle                                          AS aisle_b,
       p.pair_orders,
       ROUND(p.pair_orders * 100.0 / n.n, 3)             AS support_pct,
       ROUND(p.pair_orders * 1.0 / ta.cnt, 3)            AS conf_a_to_b,
       ROUND(p.pair_orders * 1.0 / tb.cnt, 3)            AS conf_b_to_a,
       ROUND(p.pair_orders * n.n * 1.0 / (ta.cnt * tb.cnt), 2) AS lift
FROM pairs p
CROSS JOIN n_orders n
JOIN top_products ta ON ta.product_id = p.product_a
JOIN top_products tb ON tb.product_id = p.product_b
JOIN products pa     ON pa.product_id = p.product_a
JOIN products pb     ON pb.product_id = p.product_b
JOIN aisles aa       ON aa.aisle_id   = pa.aisle_id
JOIN aisles ab       ON ab.aisle_id   = pb.aisle_id
ORDER BY lift DESC;
