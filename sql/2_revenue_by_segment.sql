-- Revenue by State
-- Which states generate the most total revenue?

WITH order_total AS (
	SELECT
		order_id,
	 	SUM(payment_value) AS order_revenue
	FROM
		payments
	GROUP BY
		order_id
	HAVING
		SUM(payment_value) > 0
),

state_order_revenue AS (
	SELECT
		c.customer_state,
		ot.order_revenue
	FROM
		order_total ot
	JOIN
		orders o
	ON
		ot.order_id = o.order_id
	JOIN
		customers c
	ON
		o.customer_id = c.customer_id
	WHERE
		o.order_status NOT IN ('canceled', 'unavailable')
)

SELECT
	customer_state,
	SUM(order_revenue) AS total_revenue,
	RANK() OVER (ORDER BY SUM(order_revenue) DESC) AS state_rank
FROM 
	state_order_revenue
GROUP BY
	customer_state
ORDER BY
	state_rank;