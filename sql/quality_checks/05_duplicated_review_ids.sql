WITH review_counts AS (
    SELECT
        review_id,
        COUNT(*) AS n_rows
    FROM raw.reviews
    GROUP BY review_id
)
SELECT
    COUNT(*) AS n_review_ids,
    n_rows AS times_repeated,
    SUM(COUNT(*)) OVER () AS total_review_ids,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS pct_review_ids,
    SUM(n_rows * COUNT(*)) OVER () AS total_rows,
    (n_rows * COUNT(*)) AS n_rows_per_multiplicity,
    ROUND(
        (n_rows * COUNT(*)) * 100.0 / SUM(n_rows * COUNT(*)) OVER (),
        2
    ) AS pct_rows_per_multiplicity
FROM review_counts
GROUP BY n_rows
ORDER BY n_rows;


WITH review_stats AS (
    SELECT
        r.review_id,
        COUNT(DISTINCT c.customer_unique_id) AS unique_customer_count,
        COUNT(DISTINCT CASE 
            WHEN o.order_status = 'delivered' THEN o.order_id 
        END) AS delivered_count
    FROM raw.reviews r
    JOIN raw.orders o USING (order_id)
    JOIN raw.customers c USING (customer_id)
    GROUP BY r.review_id
)
SELECT
    COUNT(*) AS n_review_ids,
    unique_customer_count,
    delivered_count
FROM review_stats
GROUP BY unique_customer_count, delivered_count
ORDER BY unique_customer_count, delivered_count;


SELECT
    review_id,
    COUNT(*) AS n_rows,
    COUNT(DISTINCT review_creation_date) AS distinct_timestamps,
    COUNT(DISTINCT review_answer_timestamp) AS distinct_answers
FROM raw.reviews
GROUP BY review_id
HAVING COUNT(DISTINCT review_creation_date) > 1 OR COUNT(DISTINCT review_answer_timestamp) > 1;


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