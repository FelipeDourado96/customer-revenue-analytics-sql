-- =====================================================
-- REVENUE ANALYSIS
-- =====================================================
-- Objective:
-- Analyze total and monthly revenue trends.

-- 1. Total revenue
-- Calculate total revenue based on all payment transactions
SELECT 
ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments;

-- 2. Monthly revenue
-- Aggregate revenue by purchase month
-- Used to identify growth patterns and seasonality
SELECT 
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS years_months,
ROUND(SUM(p.payment_value), 2) AS total_revenue_monthly
FROM orders AS o
INNER JOIN order_payments AS p
ON o.order_id = p.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m');

-- Note:
-- The dataset ends on October 17th, 2018.
-- Therefore, October 2018 is incomplete and revenue for this month
-- may be underestimated.
