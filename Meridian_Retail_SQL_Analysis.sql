-- ============================================================
-- MERIDIAN RETAIL GROUP
-- SQL ANALYSIS SCRIPT
-- ============================================================
-- Purpose:
-- This file brings together the 12 SQL student tasks and records
-- the main database preparation checks completed for the project.
--
-- IMPORTANT:
-- The database preparation/loading work was already carried out
-- in SQLiteStudio. The exact original staging/schema scripts are
-- separate project files (for example, staging_schema.sql and
-- schema.sql). This script does NOT recreate or reload the tables.
-- Do not rerun data-loading or UPDATE statements unless you intend
-- to change the database.
--
-- Database used: Meridian_retail_final
--
-- PREPARATION WORK COMPLETED (RECORD)
-- 1. Raw data was loaded into staging tables.
-- 2. Clean tables were created using the project schema.
-- 3. Data was transferred from staging tables into clean tables.
-- 4. Duplicate IDs and unmatched references were investigated.
-- 5. Negative order-item quantities were corrected in the clean table.
-- 6. Indexes were reviewed and an additional orders index was created.
--
-- Staging row counts recorded:
--   Stg_customers       6,090
--   Stg_products          220
--   Stg_orders         28,297
--   Stg_order_items    73,505
--   Stg_support_tickets 5,200
--
-- Clean-table row counts recorded after loading:
--   customers           6,090
--   products              220
--   orders              28,252
--   order_items         73,405
--   support_tickets      5,200
--
-- Reconciliation notes:
--   Orders: 25 extra duplicate order_id records and 20 orders
--   with unmatched customer references were identified.
--   Order items: 60 rows linked to missing orders and 40 extra
--   duplicate order_item_id records were identified in staging.
--
-- NOTE ON CHURN DEFINITIONS:
--   Task 8 below follows the SQL student brief's 180-day rule
--   and uses 1 July 2026 as the snapshot date.
--   The later Phase 7 EDA used a separate 150-day definition.
-- ============================================================


-- TASK 1: Retrieve the 20 most recent completed orders
-- PURPOSE: Display the latest completed transactions,
-- including their order ID, customer ID, date and amount.
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_status = 'Completed'
ORDER BY order_date DESC
LIMIT 20;


-- TASK 2: Analyse customers and revenue by membership tier
-- PURPOSE: Compare each membership tier by customer count,
-- completed-order revenue and average order value.
SELECT c.membership_tier,
       COUNT(DISTINCT c.customer_id) AS customer_count,
       ROUND(SUM(o.total_amount), 2) AS total_revenue,
       ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM customers AS c
LEFT JOIN orders AS o
  ON c.customer_id = o.customer_id
 AND o.order_status = 'Completed'
GROUP BY c.membership_tier
ORDER BY total_revenue DESC;


-- TASK 3: Identify the top 15 products by revenue
-- PURPOSE: Calculate product revenue using quantity multiplied
-- by unit price, then rank products from highest to lowest.
SELECT p.product_name,
       p.category,
       p.brand,
       ROUND(SUM(oi.quantity * oi.unit_price_at_purchase), 2) AS total_revenue
FROM order_items AS oi
INNER JOIN products AS p
  ON oi.product_id = p.product_id
INNER JOIN orders AS o
  ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category, p.brand
ORDER BY total_revenue DESC
LIMIT 15;


-- TASK 4: Analyse Platinum customers
-- PURPOSE: Calculate each Platinum customer's orders,
-- completed-order spending and support tickets accurately.
-- Separate summaries prevent order/ticket joins from multiplying counts.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COALESCE(o.total_orders, 0) AS total_orders,
       COALESCE(o.total_spend, 0) AS total_spend,
       COALESCE(t.support_tickets, 0) AS support_tickets
FROM customers AS c
LEFT JOIN (
    SELECT customer_id,
           COUNT(*) AS total_orders,
           ROUND(
               SUM(CASE
                       WHEN order_status = 'Completed' THEN total_amount
                       ELSE 0
                   END), 2
           ) AS total_spend
    FROM orders
    GROUP BY customer_id
) AS o
  ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT customer_id,
           COUNT(*) AS support_tickets
    FROM support_tickets
    GROUP BY customer_id
) AS t
  ON c.customer_id = t.customer_id
WHERE c.membership_tier = 'Platinum'
ORDER BY total_spend DESC;


-- TASK 5: Identify customers spending above average
-- PURPOSE: Compare each customer's completed-order spending
-- against the average completed-order spending per customer.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       ROUND(SUM(o.total_amount), 2) AS total_spend
FROM customers AS c
INNER JOIN orders AS o
  ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > (
    SELECT AVG(customer_spend)
    FROM (
        SELECT customer_id,
               SUM(total_amount) AS customer_spend
        FROM orders
        WHERE order_status = 'Completed'
        GROUP BY customer_id
    )
)
ORDER BY total_spend DESC;


-- TASK 6: Identify customers who never placed an order
-- PURPOSE: Find customers whose customer IDs do not appear
-- in the orders table.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       c.membership_tier
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders AS o
    WHERE o.customer_id = c.customer_id
)
ORDER BY c.customer_id;


-- TASK 7: Categorise orders by value
-- PURPOSE: Group orders into Low, Medium and High value bands,
-- then calculate the order count and total revenue per band.
SELECT CASE
           WHEN total_amount < 50 THEN 'Low'
           WHEN total_amount <= 200 THEN 'Medium'
           ELSE 'High'
       END AS order_value_band,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY CASE
             WHEN total_amount < 50 THEN 'Low'
             WHEN total_amount <= 200 THEN 'Medium'
             ELSE 'High'
         END
ORDER BY CASE
             WHEN order_value_band = 'Low' THEN 1
             WHEN order_value_band = 'Medium' THEN 2
             ELSE 3
         END;


-- TASK 8: Classify customers as Active or Churned
-- PURPOSE: Apply the student brief's 180-day inactivity rule,
-- using 1 July 2026 as the snapshot date.
-- A customer is Active if they placed a completed order during
-- the 180-day lookback period ending on 1 July 2026.
SELECT
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM orders AS o
            WHERE o.customer_id = c.customer_id
              AND o.order_status = 'Completed'
              AND o.order_date >= DATE('2026-07-01', '-180 days')
              AND o.order_date < '2026-07-02'
        )
        THEN 'Active'
        ELSE 'Churned'
    END AS churn_status,
    COUNT(*) AS customer_count
FROM customers AS c
GROUP BY
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM orders AS o
            WHERE o.customer_id = c.customer_id
              AND o.order_status = 'Completed'
              AND o.order_date >= DATE('2026-07-01', '-180 days')
              AND o.order_date < '2026-07-02'
        )
        THEN 'Active'
        ELSE 'Churned'
    END;


-- TASK 9: Identify product categories with high average quantity
-- PURPOSE: Find categories where the average quantity
-- purchased per order item is greater than 1.5.
SELECT p.category,
       ROUND(AVG(oi.quantity), 2) AS average_quantity
FROM order_items AS oi
INNER JOIN products AS p
  ON oi.product_id = p.product_id
GROUP BY p.category
HAVING AVG(oi.quantity) > 1.5
ORDER BY average_quantity DESC;


-- TASK 10A: Check for negative order-item quantities
-- PURPOSE: Count records with negative quantities before correction.
SELECT COUNT(*) AS negative_quantity_count
FROM order_items
WHERE quantity < 0;


-- TASK 10B: Correct negative order-item quantities
-- PURPOSE: Convert negative quantities to positive values.
-- CAUTION: This UPDATE has already been run in the project database.
-- It is included as a record; do not rerun unless correction is needed.
-- UPDATE order_items
-- SET quantity = ABS(quantity)
-- WHERE quantity < 0;


-- TASK 10C: Verify negative quantity correction
-- PURPOSE: Confirm that no negative quantities remain.
SELECT COUNT(*) AS remaining_negative_quantities
FROM order_items
WHERE quantity < 0;


-- TASK 10D: Identify exact duplicate order items
-- PURPOSE: Count extra records where the same order, product,
-- quantity and unit price appear more than once.
SELECT COALESCE(SUM(duplicate_count - 1), 0) AS extra_duplicate_records
FROM (
    SELECT COUNT(*) AS duplicate_count
    FROM order_items
    GROUP BY order_id, product_id, quantity, unit_price_at_purchase
    HAVING COUNT(*) > 1
);


-- TASK 11: Explain the importance of foreign keys
-- ANSWER:
-- A foreign key maintains referential integrity between
-- the customers and orders tables.
-- Without a foreign key, orders could reference customer IDs
-- that do not exist in the customers table.
-- In this project, 20 unmatched customer references were
-- identified in the raw orders data.
-- This could lead to inaccurate customer histories,
-- unreliable revenue reports and incorrect churn analysis.
-- Foreign keys help maintain data accuracy and consistency.


-- TASK 12A: Create an index for order searches
-- PURPOSE: Improve searches that filter orders by status
-- and sort them by order date.
-- This index was already created in the project database.
-- IF NOT EXISTS makes the statement safe to run again.
CREATE INDEX IF NOT EXISTS idx_orders_status_date
ON orders (order_status, order_date);


-- TASK 12B: Verify the orders indexes
-- PURPOSE: Display the indexes currently defined on orders.
PRAGMA index_list('orders');


-- TASK 12C: Explain the purpose and limitations of indexing
-- An index was created on order_status and order_date
-- to improve searches that filter orders by status
-- and sort them by date.
-- The index can reduce the amount of searching required
-- when retrieving matching records.
-- However, indexes do not improve every type of query.
-- They may not help queries that do not use the indexed
-- columns, and they require additional storage space.
-- Indexes can also slightly slow down INSERT, UPDATE
-- and DELETE operations because the index must be maintained.
-- CONCLUSION:
-- Indexing improves data retrieval performance, but
-- should be applied to columns frequently used in searches,
-- filtering and sorting.


-- ============================================================
-- END OF MERIDIAN RETAIL GROUP SQL ANALYSIS SCRIPT
-- ============================================================
