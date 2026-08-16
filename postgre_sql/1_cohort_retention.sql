-- Cohort retention
-- For customers who made their first purchase in each month, what percentage placed another order in the following months?

CREATE VIEW cohort_retention AS
(
	WITH customer_order AS (
		SELECT
	        c.customer_unique_id,
	        o.order_id,
	        o.order_purchase_timestamp
	    FROM
			customers c
	    JOIN
			orders o
	    ON
			c.customer_id = o.customer_id
	    WHERE
			o.order_status NOT IN ('canceled', 'unavailable')
	),
	
	first_purchase AS (
	    SELECT
	        customer_unique_id,
	        MIN(order_purchase_timestamp) AS first_order_date
	    FROM
			customer_order
	    GROUP BY
			customer_unique_id
	),
	
	extract_year_month AS (
	    SELECT
	        co.customer_unique_id,
	        order_id,
	        EXTRACT(YEAR FROM co.order_purchase_timestamp) AS order_year,
	        EXTRACT(MONTH FROM co.order_purchase_timestamp) AS order_month,
	        EXTRACT(YEAR FROM fp.first_order_date) AS first_order_year,
	        EXTRACT(MONTH FROM fp.first_order_date) AS first_order_month
	    FROM
			customer_order co
	    JOIN
			first_purchase fp
	    ON
			co.customer_unique_id = fp.customer_unique_id
	),
	
	order_period AS (
	    SELECT
	        customer_unique_id,
	        order_id,
	        CONCAT(first_order_year, ' - ', first_order_month) AS cohort_month,
	        -- Sort key: YYYYMM as integer, so Power BI/BI tools can sort chronologically
	        -- instead of alphabetically (e.g. "2016 - 9" sorting after "2016 - 12")
	        (first_order_year * 100 + first_order_month) AS cohort_sort_key,
	        ((order_year - first_order_year) * 12 + (order_month - first_order_month)) AS period_number
	    FROM
			extract_year_month
	),
	
	cohort_customers AS (
	    SELECT
	        cohort_month,
	        cohort_sort_key,
	        period_number,
	        COUNT(DISTINCT customer_unique_id) AS customers_in_period
	    FROM
			order_period
	    GROUP BY
	        cohort_month,
	        cohort_sort_key,
	        period_number
	),
	
	cohort_size_formula AS (
	    SELECT
	        cohort_month,
	        cohort_sort_key,
	        period_number,
	        customers_in_period,
	        FIRST_VALUE(customers_in_period) OVER (
	            PARTITION BY cohort_month
	            ORDER BY period_number
	        ) AS cohort_size
	    FROM
			cohort_customers
	)
	
	SELECT
	    cohort_month,
	    cohort_sort_key,
	    period_number,
	    customers_in_period,
	    cohort_size,
	    ROUND(100.0 * customers_in_period / cohort_size, 2) AS retention_rate
	FROM
		cohort_size_formula
	ORDER BY
	    cohort_sort_key,
	    period_number
);

SELECT * FROM cohort_retention;