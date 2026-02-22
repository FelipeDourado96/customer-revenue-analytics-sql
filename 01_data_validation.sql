-- =====================================================
-- DATA VALIDATION
-- =====================================================
-- Objective:
-- Perform structural validation and sanity checks
-- before starting business analysis.

-- 1. Row count validation
-- Check total number of rows in each core table
SELECT 'orders' AS table_name, COUNT(*) AS total_rows FROM orders
UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) AS total_rows FROM order_items
UNION ALL
SELECT 'order_payments' AS table_name, COUNT(*) AS total_rows FROM order_payments
UNION ALL
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS total_rows FROM products
UNION ALL
SELECT 'sellers' AS table_name, COUNT(*) AS total_rows FROM sellers;

-- 2. Primary key consistency check
-- Ensure order_id uniqueness in main tables
SELECT 
COUNT(*) AS total_orders,
COUNT(DISTINCT order_id) AS distinct_orders
FROM orders;

SELECT 
COUNT(*) AS total_payment_rows,
COUNT(DISTINCT order_id) AS distinct_orders_in_payment
FROM order_payments;

-- 3. Orders without payment
-- Identify orders that do not have a corresponding payment record
SELECT 
COUNT(*) AS orders_without_payment
FROM orders AS o
LEFT JOIN order_payments AS p
ON o.order_id = p.order_id
WHERE p.order_id IS NULL;

-- 4. Orders without items
-- Identify orders that do not have associated items
SELECT 
COUNT(*) AS orders_without_items
FROM orders AS o
LEFT JOIN order_items AS oi
ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;

-- 5. Null value check in key columns
SELECT 
COUNT(*) AS null_order_ids
FROM orders
WHERE order_id IS NULL;

SELECT 
COUNT(*) AS null_customer_ids
FROM customers
WHERE customer_id IS NULL;

SELECT 
COUNT(*) AS null_payment_values
FROM order_payments
WHERE payment_value IS NULL;

-- 6. Non-positive payment validation
-- Detect incorrect financial values
SELECT 
COUNT(*) AS non_positive_payments
FROM order_payments
WHERE payment_value <= 0;

-- 7. Date validation
-- Check for missing purchase timestamps
SELECT 
COUNT(*) AS null_purchase_dates
FROM orders
WHERE order_purchase_timestamp IS NULL;

-- 8. Payment summary sanity check
-- Basic descriptive statistics for revenue validation
SELECT 
ROUND(SUM(payment_value), 2) AS total_revenue,
ROUND(AVG(payment_value), 2) AS avg_payment,
MIN(payment_value) AS min_payment,
MAX(payment_value) AS max_payment
FROM order_payments;
