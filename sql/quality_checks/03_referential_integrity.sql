SELECT COUNT(*) AS num_customer_ids_in_orders_notin_customers
FROM raw.orders o
LEFT JOIN raw.customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


SELECT COUNT(*) AS num_customer_ids_notin_orders_in_customers
FROM raw.orders o
RIGHT JOIN raw.customers c
ON o.customer_id = c.customer_id
WHERE o.customer_id IS NULL;


SELECT COUNT(*) AS num_order_ids_in_order_items_notin_orders
FROM raw.order_items oi
LEFT JOIN raw.orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT COUNT(*) AS num_order_ids_notin_order_items_in_orders
FROM raw.order_items oi
RIGHT JOIN raw.orders o
ON oi.order_id = o.order_id
WHERE oi.order_id IS NULL;


SELECT COUNT(*) AS num_order_ids_in_reviews_notin_orders
FROM raw.reviews r
LEFT JOIN raw.orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT COUNT(*) AS num_order_ids_notin_reviews_in_orders
FROM raw.reviews r
RIGHT JOIN raw.orders o
ON r.order_id = o.order_id
WHERE r.order_id IS NULL;


SELECT COUNT(*) AS num_order_ids_in_payments_notin_orders
FROM raw.payments p
LEFT JOIN raw.orders o
ON p.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT COUNT(*) AS num_order_ids_notin_payments_in_orders
FROM raw.payments p
RIGHT JOIN raw.orders o
ON p.order_id = o.order_id
WHERE p.order_id IS NULL;
