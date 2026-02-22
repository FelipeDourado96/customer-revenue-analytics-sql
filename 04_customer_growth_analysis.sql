-- =====================================================
-- CUSTOMER GROWTH ANALYSIS
-- =====================================================
-- Objective:
-- Analyze customer acquisition trends and growth over time.

-- 1. Monthly customer growth
WITH first_purchase_table AS (
SELECT c.customer_unique_id, MIN(o.order_purchase_timestamp) AS first_purchase
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
), 
customer_growth AS (
SELECT DATE_FORMAT(first_purchase, '%Y-%m') AS years_months,
COUNT(*) AS amount_of_new_customers 
FROM first_purchase_table
GROUP BY DATE_FORMAT(first_purchase, '%Y-%m')
),
growth_with_lag AS (
SELECT *, 
LAG(amount_of_new_customers) OVER(ORDER BY years_months) AS previous_month
FROM customer_growth
)
SELECT *, 
ROUND(
		(
			amount_of_new_customers - previous_month
		) / NULLIF(previous_month, 0) * 100
	, 2) AS mom_growth_percentage,
SUM(amount_of_new_customers) OVER(ORDER BY years_months) AS total_amount_of_customers,
ROUND(AVG(amount_of_new_customers) OVER(ORDER BY years_months ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS rolling_avg_over_3_months
FROM growth_with_lag
ORDER BY years_months
;
-- 2. Month with the most amount of new customers and the least amount of new customers
-- Repeating CTE since it is scoped to a single query in MySQL
WITH first_purchase_table AS (
	SELECT c.customer_unique_id, 
	MIN(o.order_purchase_timestamp) AS first_purchase
    FROM customers c
    JOIN orders o
	ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
), 
amount_of_new_customers_monthly AS (
    SELECT DATE_FORMAT(first_purchase, '%Y-%m') AS years_months,
	COUNT(*) AS amount_of_new_customers 
    FROM first_purchase_table
    GROUP BY DATE_FORMAT(first_purchase, '%Y-%m')
),
filtered_months AS (
    SELECT *
    FROM amount_of_new_customers_monthly
    WHERE years_months <> (
        SELECT MAX(years_months)
        FROM amount_of_new_customers_monthly
    )
)

SELECT *
FROM filtered_months
WHERE amount_of_new_customers = (
        SELECT MAX(amount_of_new_customers)
        FROM filtered_months
    )
OR amount_of_new_customers = (
        SELECT MIN(amount_of_new_customers)
        FROM filtered_months
    )
;
