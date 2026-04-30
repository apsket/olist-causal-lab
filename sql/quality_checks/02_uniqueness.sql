WITH frequency_counts AS (
    SELECT 
        order_id, 
        COUNT(*) AS frequency
    FROM 
        raw.orders
    GROUP BY 
        order_id
)
SELECT 
    frequency, 
    COUNT(*) AS num_order_ids
FROM 
    frequency_counts
GROUP BY 
    frequency
ORDER BY 
    frequency DESC;


WITH frequency_counts AS (
    SELECT 
        order_id, 
        COUNT(*) AS frequency
    FROM 
        raw.order_items
    GROUP BY 
        order_id
),
aggregated_counts AS (
    SELECT 
        frequency, 
        COUNT(*) AS num_order_ids
    FROM 
        frequency_counts
    GROUP BY 
        frequency
)
SELECT 
    frequency, 
    num_order_ids,
    -- Percentage of total orders
    ROUND(100.0 * num_order_ids / SUM(num_order_ids) OVER (), 2) AS pct_of_orders,
    -- Total rows for this frequency
    (frequency * num_order_ids) AS total_rows_in_group,
    -- Percentage of total rows
    ROUND(100.0 * (frequency * num_order_ids) / SUM(frequency * num_order_ids) OVER (), 2) AS pct_of_total_rows,
    -- Weighted Average Frequency (Total Rows / Total Order IDs)
    -- This value will be the same for every row in the result set
    ROUND(
        CAST(SUM(frequency * num_order_ids) OVER () AS NUMERIC) / 
        NULLIF(SUM(num_order_ids) OVER (), 0), 
    2) AS weighted_avg_frequency
FROM 
    aggregated_counts
ORDER BY 
    frequency ASC;



WITH frequency_counts AS (
    SELECT 
        review_id, 
        COUNT(*) AS frequency
    FROM 
        raw.reviews
    GROUP BY 
        review_id
)
SELECT 
    frequency, 
    COUNT(*) AS num_review_ids
FROM 
    frequency_counts
GROUP BY 
    frequency
ORDER BY 
    frequency DESC;