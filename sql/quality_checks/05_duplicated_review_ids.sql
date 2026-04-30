WITH review_orders AS (
    SELECT
        r.review_id,
        r.order_id,
        o.order_status,
        c.customer_unique_id
    FROM raw.reviews r
    JOIN raw.orders o
        ON r.order_id = o.order_id
    JOIN raw.customers c
        ON o.customer_id = c.customer_id
),

review_agg AS (
    SELECT
        review_id,

        COUNT(DISTINCT customer_unique_id) AS unique_customer_count,
        COUNT(DISTINCT order_id) AS order_count,

        COUNT(*) FILTER (WHERE order_status = 'delivered') AS delivered_count,
        COUNT(*) FILTER (WHERE order_status <> 'delivered') AS non_delivered_count

    FROM review_orders
    GROUP BY review_id
)

SELECT *
FROM review_agg
WHERE
    unique_customer_count > 1
    OR delivered_count > 1;


SELECT
    review_id,
    COUNT(*) AS n_rows,
    COUNT(DISTINCT review_creation_date) AS distinct_timestamps,
    COUNT(DISTINCT review_answer_timestamp) AS distinct_answers
FROM raw.reviews
GROUP BY review_id
HAVING COUNT(DISTINCT review_creation_date) > 1 OR COUNT(DISTINCT review_answer_timestamp) > 1;


SELECT o.order_id, order_purchase_timestamp, product_id, seller_id, shipping_limit_date
FROM raw.orders AS o JOIN raw.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_id = 'c88b1d1b157a9999ce368f218a407141' OR o.order_id = 'c44883fc2529b4aa03ca90e7e09d95b6';


WITH review_counts AS (
    SELECT
        review_id,
        COUNT(*) AS n_rows,
        COUNT(DISTINCT order_id) AS n_orders,
        COUNT(DISTINCT product_id) AS n_products,
        COUNT(DISTINCT seller_id) AS n_sellers
    FROM raw.reviews r
    JOIN raw.order_items oi USING (order_id)
    GROUP BY review_id
)

SELECT
    CASE
        WHEN n_rows = 1 THEN 'clean'
        WHEN n_orders = 1 THEN 'order-stable'
        WHEN n_orders > 1 THEN 'multi-order'
    END AS review_type,
    COUNT(*) AS n_review_ids
FROM review_counts
GROUP BY 1;


WITH review_product_counts AS (
    SELECT
        r.review_id,
        COUNT(DISTINCT oi.product_id) AS n_products
    FROM raw.reviews r
    JOIN raw.order_items oi
        ON r.order_id = oi.order_id
    GROUP BY r.review_id
)

SELECT
    CASE
        WHEN n_products = 1 THEN 'decidable'
        ELSE 'undecidable'
    END AS product_attribution_status,
    COUNT(*) AS n_reviews
FROM review_product_counts
GROUP BY 1;