SELECT 
    COUNT(DISTINCT order_id) AS total_number_of_orders,
    COUNT(DISTINCT product_id) AS n_distinct_products,
    COUNT(DISTINCT seller_id) AS n_sellers,
    COUNT(*) FILTER (WHERE price = 0) AS n_zero_price_order_items,
    COUNT(*) FILTER (WHERE freight_value = 0) AS n_zero_freight_order_items,
    COUNT(DISTINCT order_id) FILTER (WHERE freight_value = 0) AS n_orders_with_zero_freight_items
FROM raw.order_items;


SELECT order_id AS order_id_with_inconsistent_order_item_ids
FROM raw.order_items
GROUP BY order_id
HAVING COUNT(DISTINCT order_item_id) <> MAX(order_item_id);


SELECT MIN(order_item_id) as min_order_item_id, 
    MAX(order_item_id) as max_order_item_id,
    MIN(price) as min_item_price,
    MAX(price) as max_item_price,
    MIN(freight_value) as min_item_freight_value,
    MAX(freight_value) as max_item_freight_value
FROM raw.order_items;


WITH order_totals AS (
    SELECT order_id, 
        SUM(price) AS order_total_price,
        SUM(freight_value) AS order_total_freight
    FROM raw.order_items
    GROUP BY order_id
)
SELECT
    ROUND(AVG(order_total_price), 2) AS avg_order_price,
    MIN(order_total_price) AS min_order_price,
    MAX(order_total_price) AS max_order_price,
    ROUND(AVG(order_total_freight), 2) AS avg_order_freight,
    MIN(order_total_freight) AS min_order_freight,
    MAX(order_total_freight) AS max_order_freight,
    ROUND(AVG(order_total_freight / NULLIF(order_total_price, 0)), 2) AS avg_freight_to_price_ratio,
    ROUND(AVG(order_total_price + order_total_freight), 2) AS avg_total_order_value
FROM order_totals;


WITH order_totals AS (
    SELECT order_id,
        COUNT(*) AS n_items_in_order,
        COUNT(DISTINCT product_id) AS n_distinct_products_in_order,
        COUNT(DISTINCT seller_id) AS n_distinct_sellers_in_order
    FROM raw.order_items
    GROUP BY order_id
)
SELECT
    ROUND(AVG(n_items_in_order), 2) AS order_avg_items,
    MIN(n_items_in_order) AS order_min_items,
    MAX(n_items_in_order) AS order_max_items,
    ROUND(AVG(n_distinct_products_in_order), 2) AS order_avg_distinct_products,
    MIN(n_distinct_products_in_order) AS order_min_distinct_products,
    MAX(n_distinct_products_in_order) AS order_max_distinct_products,
    ROUND(AVG(n_distinct_sellers_in_order), 2) AS order_avg_distinct_sellers,
    MIN(n_distinct_sellers_in_order) AS order_min_distinct_sellers,
    MAX(n_distinct_sellers_in_order) AS order_max_distinct_sellers
FROM order_totals;


WITH order_item_counts AS (
    SELECT
        order_id,
        COUNT(*) AS n_items
    FROM raw.order_items
    GROUP BY order_id
)
SELECT
    COUNT(*) AS n_orders,
    n_items AS n_items_in_order,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_orders
FROM order_item_counts
GROUP BY n_items
ORDER BY n_orders DESC;
