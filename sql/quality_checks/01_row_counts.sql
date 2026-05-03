SELECT 'orders' AS table_name, COUNT(*) AS row_count, COUNT(DISTINCT order_id) AS unique_ids FROM raw.orders
UNION ALL
SELECT 'order_items', COUNT(*), COUNT(DISTINCT order_id) FROM raw.order_items
UNION ALL
SELECT 'customers', COUNT(*), COUNT(DISTINCT customer_unique_id) FROM raw.customers
UNION ALL
SELECT 'products', COUNT(*), COUNT(DISTINCT product_id) FROM raw.products
UNION ALL
SELECT 'reviews', COUNT(*), COUNT(DISTINCT review_id) FROM raw.reviews
UNION ALL
SELECT 'payments', COUNT(*), COUNT(DISTINCT order_id) FROM raw.payments
UNION ALL
SELECT 'sellers', COUNT(*), COUNT(DISTINCT seller_id) FROM raw.sellers
UNION ALL
select 'geolocation', COUNT(*), COUNT(DISTINCT geolocation_zip_code_prefix) FROM raw.geolocation;