-- AOV (Average Order Value) Trend Over Time
-- What is the average order value by month?

WITH total_payments_by_order AS (
	SELECT
		order_id,
		SUM(payment_value) AS total_payments
	FROM
		payments
	GROUP BY
		order_id
	HAVING
		SUM(payment_value) > 0
),

order_period AS (
	SELECT
		order_id,
		DATE_TRUNC('month', order_purchase_timestamp) AS period
	FROM
		orders
	WHERE
		order_status NOT IN ('canceled', 'unavailable')
)

SELECT
	TO_CHAR(op.period, 'YYYY-MM') AS period,
	ROUND(AVG(tpo.total_payments), 2) AS average_order_value
FROM
	total_payments_by_order tpo
JOIN
	order_period op
ON
	tpo.order_id = op.order_id
GROUP BY
	op.period
ORDER BY
	op.period ASC;