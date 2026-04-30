SELECT 'orders' AS table_name, COUNT(*) FROM raw.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM raw.order_items
UNION ALL
SELECT 'customers', COUNT(*) FROM raw.customers
UNION ALL
SELECT 'products', COUNT(*) FROM raw.products
UNION ALL
SELECT 'reviews', COUNT(*) FROM raw.reviews
UNION ALL
SELECT 'payments', COUNT(*) FROM raw.payments;