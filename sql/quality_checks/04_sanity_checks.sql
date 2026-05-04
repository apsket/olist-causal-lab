SELECT COUNT(*) as num_invalid_customers
FROM raw.customers
WHERE customer_id IS NULL OR customer_id = ''
    OR customer_unique_id IS NULL OR customer_unique_id = ''
    OR customer_zip_code_prefix IS NULL OR customer_zip_code_prefix < 0
    OR customer_city IS NULL OR customer_city = ''
    OR customer_state IS NULL OR customer_state = '';


SELECT COUNT(*) as num_invalid_orders
FROM raw.orders
WHERE order_id IS NULL OR order_id = ''
    OR customer_id IS NULL OR customer_id = ''
    OR order_delivered_customer_date < order_purchase_timestamp
    OR order_approved_at < order_purchase_timestamp
    OR order_estimated_delivery_date < order_purchase_timestamp;


SELECT COUNT(*) as num_invalid_payments
FROM raw.payments
WHERE order_id IS NULL OR order_id = '' 
    OR payment_sequential IS NULL OR payment_sequential < 0
    OR payment_installments IS NULL OR payment_installments < 0
    OR payment_value IS NULL OR payment_value < 0;


SELECT MIN(payment_sequential) as min_payment_sequential,
    MAX(payment_sequential) as max_payment_sequential,
    MIN(payment_installments) as min_payment_installments,
    MAX(payment_installments) as max_payment_installments,
    MIN(payment_value) as min_payment_value,
    MAX(payment_value) as max_payment_value
FROM raw.payments;


SELECT COUNT(*) as num_invalid_reviews
FROM raw.reviews
WHERE review_id IS NULL OR review_id = ''
    OR order_id IS NULL OR order_id = ''
    OR review_score < 1 OR review_score > 5
    OR review_creation_date IS NULL
    OR review_answer_timestamp IS NULL
    OR review_creation_date > review_answer_timestamp;


SELECT COUNT(*) as num_invalid_geolocations
FROM raw.geolocation
WHERE geolocation_city IS NULL OR geolocation_city = ''
    OR geolocation_state IS NULL OR geolocation_state = ''
    OR geolocation_lat IS NULL OR geolocation_lng IS NULL 
    OR geolocation_lat < -90 OR geolocation_lat > 90 
    OR geolocation_lng < -180 OR geolocation_lng > 180;


SELECT COUNT(*) as num_geolocations_outisde_brazil
FROM raw.geolocation
WHERE geolocation_lat < -33.75 OR geolocation_lat > 5.27 OR geolocation_lng < -73.99 OR geolocation_lng > -34.79;


SELECT COUNT(*) as num_invalid_order_items
FROM raw.order_items
WHERE order_id IS NULL OR order_id = '' 
    OR order_item_id IS NULL OR order_item_id < 1 
    OR product_id IS NULL OR product_id = '' 
    OR seller_id IS NULL OR seller_id = ''
    OR price IS NULL OR price <= 0
    OR freight_value IS NULL OR freight_value < 0;


SELECT MIN(order_item_id) as min_order_item_id, 
    MAX(order_item_id) as max_order_item_id,
    MIN(price) as min_price,
    MAX(price) as max_price,
    MIN(freight_value) as min_freight_value
FROM raw.order_items;


SELECT COUNT(*) as num_invalid_products
FROM raw.products
WHERE product_id IS NULL OR product_id = ''
    OR product_name_lenght < 0
    OR product_description_lenght < 0
    OR product_photos_qty < 0
    OR product_weight_g < 0
    OR product_length_cm < 0
    OR product_height_cm < 0
    OR product_width_cm < 0;


SELECT COUNT(*) as num_invalid_sellers
FROM raw.sellers
WHERE seller_id IS NULL OR seller_id = ''
    OR seller_zip_code_prefix IS NULL OR seller_zip_code_prefix < 0;
