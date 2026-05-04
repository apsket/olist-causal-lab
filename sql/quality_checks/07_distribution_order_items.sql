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
    ROUND(AVG(price), 2) as avg_item_price,
    MIN(price) as min_item_price,
    MAX(price) as max_item_price,
    ROUND(AVG(freight_value), 2) as avg_item_freight_value,
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


WITH order_distinct_product_counts AS (
    SELECT
        order_id,
        COUNT(DISTINCT product_id) AS n_distinct_products
    FROM raw.order_items
    GROUP BY order_id
)
SELECT
    COUNT(*) AS n_orders,
    n_distinct_products AS n_distinct_products_in_order,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_orders
FROM order_distinct_product_counts
GROUP BY n_distinct_products
ORDER BY n_orders DESC;


WITH order_distinct_seller_counts AS (
    SELECT
        order_id,
        COUNT(DISTINCT seller_id) AS n_distinct_sellers
    FROM raw.order_items
    GROUP BY order_id
)
SELECT
    COUNT(*) AS n_orders,
    n_distinct_sellers AS n_distinct_sellers_in_order,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_orders
FROM order_distinct_seller_counts
GROUP BY n_distinct_sellers
ORDER BY n_orders DESC;


WITH product_frequencies AS (
    SELECT 
        product_id,
        COUNT(*) AS sale_count,
        COUNT(DISTINCT order_id) AS n_orders_sold_in,
        COUNT(DISTINCT seller_id) AS n_sellers_sold_by,
        ROUND(AVG(price), 2) AS avg_price,
        ROUND(AVG(freight_value), 2) AS avg_freight_value
    FROM raw.order_items
    GROUP BY product_id
)
SELECT 
    ROUND(AVG(sale_count), 2) AS prod_avg_sales,
    MIN(sale_count) AS prod_min_sales,
    MAX(sale_count) AS prod_max_sales,
    ROUND(AVG(n_orders_sold_in), 2) AS prod_avg_orders_sold,
    MIN(n_orders_sold_in) AS prod_min_orders_sold,
    MAX(n_orders_sold_in) AS prod_max_orders_sold,
    ROUND(AVG(n_sellers_sold_by), 2) AS prod_avg_sellers_sold,
    MIN(n_sellers_sold_by) AS prod_min_sellers_sold,
    MAX(n_sellers_sold_by) AS prod_max_sellers_sold,
    ROUND(AVG(avg_price), 2) AS prod_avg_price,
    ROUND(AVG(avg_freight_value), 2) AS prod_avg_freight_value
FROM product_frequencies;


WITH product_frequencies AS (
    SELECT 
        product_id,
        COUNT(*) AS sale_count
    FROM raw.order_items
    GROUP BY product_id
)
SELECT 
    sale_count AS n_sales,
    COUNT(*) AS n_products,
    -- Percentage of your catalog that reached this sale count
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_catalog
FROM product_frequencies
GROUP BY sale_count
ORDER BY sale_count ASC;


-- WITH product_sales_counts AS (
--     SELECT 
--         product_id,
--         COUNT(*) AS n_sales
--     FROM raw.order_items
--     GROUP BY product_id
-- ),
-- decile_assignment AS (
--     SELECT 
--         n_sales,
--         -- Divide all unique products into 10 equal groups by popularity
--         NTILE(10) OVER (ORDER BY n_sales ASC) AS decile
--     FROM product_sales_counts
-- )
-- SELECT 
--     decile,
--     MIN(n_sales) AS min_sales_in_decile,
--     MAX(n_sales) AS max_sales_in_decile,
--     -- The gap between the least and most sold product in this slice
--     MAX(n_sales) - MIN(n_sales) AS bucket_delta,
--     COUNT(*) AS n_products_in_decile,
--     -- Percentage of total orders captured by this 10% of products
--     ROUND(100.0 * SUM(n_sales) / SUM(SUM(n_sales)) OVER(), 2) AS pct_total_order_volume
-- FROM decile_assignment
-- GROUP BY decile
-- ORDER BY decile;


WITH product_sales_counts AS (
    SELECT 
        product_id,
        COUNT(*) AS n_sales
    FROM raw.order_items
    GROUP BY product_id
),
decile_assignment AS (
    SELECT 
        n_sales,
        -- Sorting ASC so Decile 10 is the "Bestsellers"
        NTILE(10) OVER (ORDER BY n_sales ASC) AS decile
    FROM product_sales_counts
),
decile_metrics AS (
    SELECT 
        decile,
        MIN(n_sales) AS min_sales,
        MAX(n_sales) AS max_sales,
        COUNT(*) AS n_products,
        SUM(n_sales) AS total_sales_in_decile,
        -- % of total volume contributed by THIS decile
        100.0 * SUM(n_sales) / SUM(SUM(n_sales)) OVER() AS pct_vol,
        SUM(SUM(n_sales)) OVER() AS total_sales_all_products
    FROM decile_assignment
    GROUP BY decile
)
SELECT 
    decile,
    min_sales,
    max_sales,
    n_products,
    ROUND(pct_vol, 2) AS pct_total_order_volume,
    -- NEW: Accumulated % of total order volume
    ROUND(SUM(pct_vol) OVER (ORDER BY decile ASC), 2) AS cumulative_pct_volume,
    total_sales_all_products
FROM decile_metrics
ORDER BY decile;


WITH price_range AS (
    SELECT 
        MIN(price) AS min_price,
        MAX(price) AS max_price,
        -- Calculate width for exactly 10 bins
        ROUND((MAX(price) - MIN(price)) / 10.0, 2) AS bin_width
    FROM raw.order_items
),
binned_items AS (
    SELECT 
        price,
        -- Assign price to a bin 1 through 10
        LEAST(
            FLOOR((price - r.min_price) / NULLIF(r.bin_width, 0)), 
            9
        ) + 1 AS bin_number,
        r.min_price,
        r.bin_width
    FROM raw.order_items, price_range r
)
SELECT 
    bin_number,
    ROUND(min_price + ((bin_number - 1) * bin_width), 2) AS price_range_start,
    ROUND(min_price + (bin_number * bin_width), 2) AS price_range_end,
    bin_width,
    COUNT(*) AS n_order_items,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_order_items
FROM binned_items
GROUP BY bin_number, min_price, bin_width
ORDER BY bin_number;


WITH price_deciles AS (
    SELECT 
        price,
        -- Divide all items into 10 groups of equal row counts
        NTILE(10) OVER (ORDER BY price ASC) AS decile
    FROM raw.order_items
)
SELECT 
    decile,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    -- Calculate the price spread (delta) for this specific decile
    ROUND(MAX(price) - MIN(price), 2) AS bucket_delta,
    COUNT(*) AS n_items,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_items
FROM price_deciles
GROUP BY decile
ORDER BY decile;


WITH product_averages AS (
    SELECT 
        product_id,
        ROUND(AVG(price), 2) AS avg_product_price
    FROM raw.order_items
    GROUP BY product_id
),
product_deciles AS (
    SELECT 
        avg_product_price,
        -- Divide distinct products into 10 equal groups
        NTILE(10) OVER (ORDER BY avg_product_price ASC) AS decile
    FROM product_averages
)
SELECT 
    decile,
    MIN(avg_product_price) AS min_avg_product_price,
    MAX(avg_product_price) AS max_avg_product_price,
    -- The price spread for this 10% of products
    ROUND(MAX(avg_product_price) - MIN(avg_product_price), 2) AS bucket_delta,
    COUNT(*) AS n_products,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_products,
    SUM(COUNT(*)) OVER() AS total_applicable_products
FROM product_deciles
GROUP BY decile
ORDER BY decile;


WITH product_volatility AS (
    SELECT 
        product_id,
        -- Calculate how much the price varies for each product
        STDDEV(price) AS price_stddev
    FROM raw.order_items
    GROUP BY product_id
    -- We filter for products with at least 2 sales, 
    -- as stddev of a single value is mathematically undefined (NULL)
    HAVING COUNT(*) > 1
),
volatility_deciles AS (
    SELECT 
        price_stddev,
        -- Group products into 10 equal buckets based on their price variance
        NTILE(10) OVER (ORDER BY price_stddev ASC) AS decile
    FROM product_volatility
)
SELECT 
    decile,
    ROUND(MIN(price_stddev), 2) AS min_stddev,
    ROUND(MAX(price_stddev), 2) AS max_stddev,
    ROUND(MAX(price_stddev) - MIN(price_stddev), 2) AS bucket_delta,
    COUNT(*) AS n_products,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_products,
    SUM(COUNT(*)) OVER() AS total_applicable_products
FROM volatility_deciles
GROUP BY decile
ORDER BY decile;



WITH product_stats AS (
    SELECT 
        product_id,
        AVG(price) AS avg_price,
        STDDEV(price) AS stddev_price,
        -- CV = StdDev / Mean (using NULLIF to avoid division by zero)
        STDDEV(price) / NULLIF(AVG(price), 0) AS coefficient_of_variation
    FROM raw.order_items
    GROUP BY product_id
    HAVING COUNT(*) > 1 AND AVG(price) > 0
),
cv_deciles AS (
    SELECT 
        coefficient_of_variation,
        -- Group products into 10 groups based on their relative volatility
        NTILE(10) OVER (ORDER BY coefficient_of_variation ASC) AS decile
    FROM product_stats
)
SELECT 
    decile,
    ROUND(MIN(coefficient_of_variation), 4) AS min_cv,
    ROUND(MAX(coefficient_of_variation), 4) AS max_cv,
    ROUND(MAX(coefficient_of_variation) - MIN(coefficient_of_variation), 4) AS cv_delta,
    COUNT(*) AS n_products,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_products,
    SUM(COUNT(*)) OVER() AS total_applicable_products
FROM cv_deciles
GROUP BY decile
ORDER BY decile;


WITH product_stats AS (
    SELECT 
        product_id,
        COUNT(*) AS n_sales,
        AVG(price) AS avg_price,
        -- CV calculation
        STDDEV(price) / NULLIF(AVG(price), 0) AS cv
    FROM raw.order_items
    GROUP BY product_id
    HAVING COUNT(*) > 1 AND AVG(price) > 0
),
cv_deciles AS (
    SELECT 
        *,
        NTILE(10) OVER (ORDER BY cv ASC) AS decile
    FROM product_stats
)
SELECT 
    decile,
    ROUND(MIN(cv), 4) AS min_cv,
    ROUND(MAX(cv), 4) AS max_cv,
    COUNT(*) AS n_products,
    -- Average sales volume for products in this CV bucket
    ROUND(AVG(n_sales), 2) AS avg_sales_per_product,
    -- Standard deviation of sales volume in this CV bucket
    ROUND(STDDEV(n_sales), 2) AS stddev_sales_per_product,
    -- Total volume percentage for context
    ROUND(100.0 * SUM(n_sales) / SUM(SUM(n_sales)) OVER(), 2) AS pct_total_volume
FROM cv_deciles
GROUP BY decile
ORDER BY decile;


WITH product_stats AS (
    SELECT 
        product_id,
        COUNT(*) AS n_sales,
        COUNT(DISTINCT seller_id) AS n_sellers,
        AVG(price) AS avg_price,
        -- Coefficient of Variation
        STDDEV(price) / NULLIF(AVG(price), 0) AS cv
    FROM raw.order_items
    GROUP BY product_id
    HAVING COUNT(*) > 1 AND AVG(price) > 0
),
cv_deciles AS (
    SELECT 
        *,
        NTILE(10) OVER (ORDER BY cv ASC) AS decile
    FROM product_stats
)
SELECT 
    decile,
    ROUND(MIN(cv), 4) AS min_cv,
    ROUND(MAX(cv), 4) AS max_cv,
    COUNT(*) AS n_products,
    -- Sales Volume Metrics
    ROUND(AVG(n_sales), 2) AS avg_sales_per_prod,
    ROUND(STDDEV(n_sales), 2) AS stddev_sales_per_prod,
    -- Seller Competition Metrics
    ROUND(AVG(n_sellers), 2) AS avg_sellers_per_prod,
    ROUND(STDDEV(n_sellers), 2) AS stddev_sellers_per_prod,
    -- Contextual Volume
    ROUND(100.0 * SUM(n_sales) / SUM(SUM(n_sales)) OVER(), 2) AS pct_total_sales_vol,
    ROUND(SUM(SUM(n_sales)) OVER (ORDER BY decile) * 100.0 / SUM(SUM(n_sales)) OVER (), 2) AS cumulative_sales_pct
FROM cv_deciles
GROUP BY decile
ORDER BY decile;


WITH product_stats AS (
    SELECT 
        product_id,
        COUNT(*) AS n_sales,
        COUNT(DISTINCT seller_id) AS n_sellers,
        AVG(price) AS avg_price,
        STDDEV(price) / NULLIF(AVG(price), 0) AS cv
    FROM raw.order_items
    GROUP BY product_id
    HAVING COUNT(*) > 1 AND AVG(price) > 0
),
decile_assignment AS (
    SELECT 
        *,
        NTILE(10) OVER (ORDER BY cv ASC) AS decile
    FROM product_stats
),
ranked_samples AS (
    SELECT 
        *,
        -- Assign a random-ish rank to products within each decile
        ROW_NUMBER() OVER (PARTITION BY decile ORDER BY n_sales DESC) AS sample_rank
    FROM decile_assignment
)
SELECT 
    decile,
    product_id,
    ROUND(cv, 4) AS product_cv,
    n_sales,
    n_sellers,
    ROUND(avg_price, 2) AS avg_price
FROM ranked_samples
WHERE sample_rank <= 3  -- Change this number to see more or fewer samples per decile
ORDER BY decile ASC, product_cv ASC;
