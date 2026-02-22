-- =====================================================
-- ORDER & AVERAGE ORDER VALUE (AOV)
-- =====================================================
-- Objective:
-- Analyze the growth of the revenue in comparison to the AOV

-- 1. Amount of paid orders
-- Count the number of paid orders
-- (orders with at least one payment record)
SELECT 
COUNT(DISTINCT order_id) AS amount_of_paid_orders
FROM order_payments;

-- 2. Average Order Value (AOV)
-- Calculate monthly revenue, order volume, and AOV
-- Used to evaluate whether revenue growth is driven by volume or customer spending behavior
WITH aov_table AS
(
SELECT 
YEAR(o.order_purchase_timestamp) AS year, 
MONTH(o.order_purchase_timestamp) AS month,
COUNT(DISTINCT op.order_id) AS amount_of_orders,
ROUND(SUM(op.payment_value), 2) AS revenue
FROM order_payments AS op
JOIN orders AS o
ON op.order_id = o.order_id
GROUP BY YEAR(o.order_purchase_timestamp), 
MONTH(o.order_purchase_timestamp)
)
SELECT 
*, 
ROUND((revenue / amount_of_orders), 2) AS average_order_value
FROM aov_table
ORDER BY year, month;

-- Checking the last purchase date
SELECT 
MAX(order_purchase_timestamp) AS last_purchase 
FROM orders;
-- October 17th is the last purchase date in this dataset, meaning
-- that it is not a complete month, may lead to an underestimation
-- of October's performance