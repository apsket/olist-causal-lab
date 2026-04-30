SELECT COUNT(*)
FROM raw.orders
WHERE order_delivered_customer_date < order_purchase_timestamp;

SELECT MIN(payment_value), MAX(payment_value)
FROM raw.payments;

SELECT *
FROM raw.reviews
WHERE review_score < 1 OR review_score > 5;