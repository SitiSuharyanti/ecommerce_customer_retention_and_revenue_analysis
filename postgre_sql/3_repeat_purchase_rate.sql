-- Repeat Purchase Rate
-- What percentage of customers placed more than one order?

WITH customer_order_count AS (
	SELECT
		c.customer_unique_id,
		COUNT(DISTINCT(o.order_id)) AS total_order
	FROM
		customers c
	JOIN
		orders o
	ON
		c.customer_id = o.customer_id
	WHERE
		o.order_status NOT IN ('canceled', 'unavailable')
	GROUP BY
		c.customer_unique_id
),

customer_category AS (
	SELECT
		customer_unique_id,
		total_order,
		CASE
			WHEN total_order > 1 THEN 'Repeat'
			ELSE 'One time'
		END AS classify_customer
	FROM
		customer_order_count
)

SELECT
	COUNT(*) AS total_customers,
	COUNT(*) FILTER (WHERE classify_customer = 'Repeat') AS repeat_customers,
	ROUND((100.0 * COUNT (*) FILTER (WHERE classify_customer = 'Repeat') / COUNT (*)), 2) AS customer_repeat_rate
FROM
	customer_category;

-- Create View

CREATE VIEW repeat_purchase_summary AS
(
	WITH customer_order_count AS (
		SELECT
			c.customer_unique_id,
			COUNT(DISTINCT(o.order_id)) AS total_order
		FROM
			customers c
		JOIN
			orders o
		ON
			c.customer_id = o.customer_id
		WHERE
			o.order_status NOT IN ('canceled', 'unavailable')
		GROUP BY
			c.customer_unique_id
	),
	customer_category AS (
		SELECT
			customer_unique_id,
			total_order,
			CASE
				WHEN total_order > 1 THEN 'Repeat'
				ELSE 'One time'
			END AS classify_customer
		FROM
			customer_order_count
	)
	SELECT
		classify_customer,
		COUNT(*) AS customer_count
	FROM
		customer_category
	GROUP BY
		classify_customer
);

SELECT * FROM repeat_purchase_summary;