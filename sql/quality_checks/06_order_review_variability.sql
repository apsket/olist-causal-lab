SELECT 
    COUNT(*) AS n_orders_with_reviews,
    n_reviews
FROM (
    SELECT
        order_id,
        COUNT(*) AS n_reviews
    FROM raw.reviews
    GROUP BY order_id
    HAVING COUNT(*) > 1
) t
GROUP BY n_reviews;


SELECT
    COUNT(*) AS n_orders_with_multiple_reviews,

    SUM((score_variety > 1)::int) AS orders_with_score_variation,
    SUM((message_variety > 1)::int) AS orders_with_message_variation

FROM (
    SELECT
        order_id,

        COUNT(*) AS n_reviews,

        COUNT(DISTINCT COALESCE(review_score::text, '__NULL__')) 
            AS score_variety,

        COUNT(DISTINCT COALESCE(review_comment_message, '__NULL__')) 
            AS message_variety

    FROM raw.reviews
    GROUP BY order_id
    HAVING COUNT(*) > 1
) t;


WITH multi_review_orders AS (
    SELECT order_id
    FROM raw.reviews
    GROUP BY order_id
    HAVING COUNT(*) > 1
)

SELECT
    COUNT(*) AS n_orders,
    SUM((n_products > 1)::int) AS orders_with_multiple_products,
    AVG(n_products) AS avg_products_per_order
FROM (
    SELECT
        m.order_id,
        COUNT(DISTINCT oi.product_id) AS n_products
    FROM multi_review_orders m
    JOIN raw.order_items oi
        ON m.order_id = oi.order_id
    GROUP BY m.order_id
) t;

WITH multi_review_orders AS (
    SELECT order_id
    FROM raw.reviews
    GROUP BY order_id
    HAVING COUNT(*) > 1
)

SELECT m.order_id
FROM multi_review_orders m
LEFT JOIN raw.order_items oi
    ON m.order_id = oi.order_id
WHERE oi.order_id IS NULL;
