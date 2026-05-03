SELECT COUNT(*) as num_invalid_order_dates
FROM raw.orders
WHERE order_delivered_customer_date < order_purchase_timestamp;

SELECT MIN(payment_value) as min_payment_value, MAX(payment_value) as max_payment_value
FROM raw.payments;

SELECT COUNT(*) as num_invalid_review_scores
FROM raw.reviews
WHERE review_score < 1 OR review_score > 5;