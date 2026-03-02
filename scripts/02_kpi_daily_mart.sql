-- ==============================================================================
-- 02: Daily KPI Data Mart
-- Purpose: Aggregate daily revenue, orders, customers, and AOV.
-- Output: kpi_daily table for time-series trend analysis.
-- ==============================================================================

DROP TABLE IF EXISTS kpi_daily;

CREATE TABLE kpi_daily AS
WITH paid_per_order AS (
  SELECT
    order_id,
    SUM(payment_value) AS paid_value
  FROM payments
  GROUP BY order_id
),
daily_orders AS (
  SELECT
    DATE(order_purchase_timestamp) AS dt,
    order_id,
    customer_id
  FROM orders
  WHERE order_purchase_timestamp IS NOT NULL
)
SELECT
  d.dt,
  COUNT(DISTINCT d.order_id) AS orders,
  COUNT(DISTINCT d.customer_id) AS customers,
  SUM(COALESCE(p.paid_value, 0)) AS revenue,
  ROUND(
    CASE WHEN COUNT(DISTINCT d.order_id) = 0 THEN NULL
         ELSE SUM(COALESCE(p.paid_value, 0)) * 1.0 / COUNT(DISTINCT d.order_id)
    END
  , 2) AS aov
FROM daily_orders d
LEFT JOIN paid_per_order p
  ON d.order_id = p.order_id
GROUP BY d.dt
ORDER BY d.dt;

-- Quality check on the generated mart
SELECT 
  COUNT(*) AS n_days, 
  MIN(dt) AS min_dt, 
  MAX(dt) AS max_dt 
FROM kpi_daily;