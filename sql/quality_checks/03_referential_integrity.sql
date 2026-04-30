SELECT COUNT(*)
FROM raw.orders o
LEFT JOIN raw.customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*)
FROM raw.order_items oi
LEFT JOIN raw.orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*)
FROM raw.reviews r
LEFT JOIN raw.orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;