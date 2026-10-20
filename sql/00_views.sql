-- Base views over the Parquet files. {data} is replaced with the parquet folder path.
CREATE OR REPLACE VIEW orders AS
SELECT * REPLACE (CAST(order_hour_of_day AS INTEGER) AS order_hour_of_day)
FROM '{data}/orders.parquet'
WHERE eval_set = 'prior';
CREATE OR REPLACE VIEW order_products AS SELECT * FROM '{data}/order_products.parquet';
CREATE OR REPLACE VIEW products       AS SELECT * FROM '{data}/products.parquet';
CREATE OR REPLACE VIEW aisles         AS SELECT * FROM '{data}/aisles.parquet';
CREATE OR REPLACE VIEW departments    AS SELECT * FROM '{data}/departments.parquet';

-- One row per order line with product hierarchy attached.
CREATE OR REPLACE VIEW order_lines AS
SELECT op.order_id,
       op.product_id,
       op.add_to_cart_order,
       op.reordered,
       p.product_name,
       a.aisle,
       d.department
FROM order_products op
JOIN products    p USING (product_id)
JOIN aisles      a USING (aisle_id)
JOIN departments d USING (department_id);
