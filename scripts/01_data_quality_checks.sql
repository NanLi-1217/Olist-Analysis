
-- ==============================================================================
-- 01: Data Profiling & Quality Checks
-- Purpose: Validate row counts, missing keys, duplicates, and join integrity.
-- Output: dq_summary table for dashboard reporting.
-- ==============================================================================

-- 1. Initial Row Counts Profiling
SELECT 'orders' AS tbl, COUNT(*) AS n FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'customers', COUNT(*) FROM customers;

-- 2. Comprehensive Data Quality Summary
DROP TABLE IF EXISTS dq_summary;

CREATE TABLE dq_summary AS
WITH base AS (
  SELECT
    (SELECT COUNT(*) FROM orders) AS n_orders,
    (SELECT COUNT(*) FROM order_items) AS n_order_items,
    (SELECT COUNT(*) FROM payments) AS n_payments,
    (SELECT COUNT(*) FROM customers) AS n_customers,

    -- key missingness
    (SELECT COUNT(*) FROM orders WHERE order_id IS NULL) AS orders_missing_order_id,
    (SELECT COUNT(*) FROM orders WHERE customer_id IS NULL) AS orders_missing_customer_id,
    (SELECT COUNT(*) FROM orders WHERE order_purchase_timestamp IS NULL) AS orders_missing_purchase_ts,

    -- duplicates
    (SELECT COUNT(*) - COUNT(DISTINCT order_id) FROM orders) AS duplicate_order_id_count,
    (SELECT COUNT(*) - COUNT(DISTINCT customer_id) FROM customers) AS duplicate_customer_id_count,

    -- join integrity
    (SELECT COUNT(*)
     FROM orders o
     LEFT JOIN customers c ON o.customer_id = c.customer_id
     WHERE c.customer_id IS NULL
    ) AS orders_without_customer_match,

    (SELECT COUNT(*)
     FROM payments p
     LEFT JOIN orders o ON p.order_id = o.order_id
     WHERE o.order_id IS NULL
    ) AS payments_without_order_match,

    (SELECT COUNT(*)
     FROM order_items i
     LEFT JOIN orders o ON i.order_id = o.order_id
     WHERE o.order_id IS NULL
    ) AS items_without_order_match,

    -- reconciliation (money)
    (SELECT ROUND(SUM(payment_value), 2) FROM payments) AS total_payments_value,
    (SELECT ROUND(SUM(price), 2) FROM order_items) AS total_items_price,
    (SELECT ROUND(SUM(freight_value), 2) FROM order_items) AS total_items_freight
)
SELECT * FROM base;

-- 3. Review the Data Quality Results
SELECT * FROM dq_summary;