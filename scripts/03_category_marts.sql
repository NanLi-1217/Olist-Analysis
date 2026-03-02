-- ==============================================================================
-- 03: Category Performance Data Marts
-- Purpose: Calculate total payment value and delivered volume per product category.
-- Output: category_payment and category_delivered tables.
-- ==============================================================================

-- 1. Category by Payment Value
DROP TABLE IF EXISTS category_payment;

CREATE TABLE category_payment AS
WITH paid_per_order AS (
  SELECT
    order_id,
    SUM(payment_value) AS paid_value
  FROM payments
  GROUP BY order_id
),
order_total_price AS (
  SELECT
    order_id,
    SUM(price) AS total_price
  FROM order_items
  GROUP BY order_id
),
item_with_category AS (
  SELECT
    oi.order_id,
    oi.product_id,
    oi.price,
    p.product_category_name
  FROM order_items oi
  LEFT JOIN products p
    ON oi.product_id = p.product_id
)

SELECT
  COALESCE(t.product_category_name_english, iwc.product_category_name, 'unknown') AS category,
  ROUND(SUM(
    CASE
      WHEN otp.total_price IS NULL OR otp.total_price = 0 THEN 0
      ELSE COALESCE(ppo.paid_value, 0) * (iwc.price * 1.0 / otp.total_price)
    END
  ), 2) AS payment_value
FROM item_with_category iwc
LEFT JOIN paid_per_order ppo
  ON iwc.order_id = ppo.order_id
LEFT JOIN order_total_price otp
  ON iwc.order_id = otp.order_id
LEFT JOIN product_category_name_translation t
  ON iwc.product_category_name = t.product_category_name
GROUP BY 1;

-- 2. Category by Delivered Amount
DROP TABLE IF EXISTS category_delivered;

CREATE TABLE category_delivered AS
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
  COUNT(*) AS delivered_count
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
LEFT JOIN products p
  ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
  ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1;