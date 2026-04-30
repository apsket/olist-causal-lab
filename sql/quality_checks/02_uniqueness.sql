SELECT order_id, COUNT(*)
FROM raw.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM raw.order_items
GROUP BY order_id
ORDER BY COUNT(*) DESC
LIMIT 10;

SELECT review_id, COUNT(*)
FROM raw.reviews
GROUP BY review_id
HAVING COUNT(*) > 1;