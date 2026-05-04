WITH customer_counts AS (
    SELECT
        customer_unique_id,
        COUNT(*) AS occurence_count
    FROM raw.customers
    GROUP BY customer_unique_id
)
SELECT
    occurence_count AS n_orders,
    COUNT(*) AS n_unique_customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_unique_customers
FROM customer_counts
GROUP BY occurence_count
ORDER BY occurence_count;


WITH customer_loc_distribution AS (
    SELECT customer_unique_id,
        COUNT(DISTINCT customer_zip_code_prefix) AS n_zip_codes,
        COUNT(DISTINCT customer_city) AS n_cities,
        COUNT(DISTINCT customer_state) AS n_states
    FROM raw.customers
    GROUP BY customer_unique_id
)
SELECT COUNT(*) AS n_customers_with_multi_locations
FROM customer_loc_distribution
WHERE n_zip_codes > 1
    OR n_cities > 1
    OR n_states > 1;


WITH customer_zip_distribution AS (
    SELECT customer_unique_id,
        COUNT(DISTINCT customer_zip_code_prefix) AS n_zip_codes
    FROM raw.customers
    GROUP BY customer_unique_id
)
SELECT n_zip_codes, COUNT(*) AS n_customers
FROM customer_zip_distribution
GROUP BY n_zip_codes
ORDER BY n_zip_codes;


WITH customer_city_distribution AS (
    SELECT customer_unique_id,
        COUNT(DISTINCT customer_city) AS n_cities
    FROM raw.customers
    GROUP BY customer_unique_id
)
SELECT n_cities AS n_cities_per_customer, COUNT(*) AS n_customers
FROM customer_city_distribution
GROUP BY n_cities
ORDER BY n_cities;


WITH customer_state_distribution AS (
    SELECT customer_unique_id,
        COUNT(DISTINCT customer_state) AS n_states
    FROM raw.customers
    GROUP BY customer_unique_id
)
SELECT n_states AS n_states_per_customer, COUNT(*) AS n_customers
FROM customer_state_distribution
GROUP BY n_states
ORDER BY n_states;


SELECT customer_state,
    COUNT(DISTINCT customer_unique_id) AS n_unique_customers,
    ROUND(100.0 * COUNT(DISTINCT customer_unique_id) / SUM(COUNT(DISTINCT customer_unique_id)) OVER(), 2) AS pct_unique_customers,
    COUNT(*) AS n_orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_orders
FROM raw.customers
GROUP BY customer_state
ORDER BY n_unique_customers DESC;


WITH city_state_distribution AS (
    SELECT 
        customer_city,
        customer_state,
        COUNT(DISTINCT customer_unique_id) AS n_unique_customers
    FROM raw.customers
    GROUP BY customer_city, customer_state
),
range_bounds AS (
    -- Calculate the total span once
    SELECT 
        MIN(n_unique_customers) AS overall_min,
        MAX(n_unique_customers) AS overall_max,
        (MAX(n_unique_customers) - MIN(n_unique_customers)) / 10.0 AS bin_width
    FROM city_state_distribution
),
binned_data AS (
    SELECT 
        d.n_unique_customers,
        -- We use LEAST to ensure the absolute MAX value doesn't create an 11th bin
        LEAST(
            FLOOR((d.n_unique_customers - r.overall_min) / NULLIF(r.bin_width, 0)), 
            9
        ) + 1 AS bin_number,
        r.overall_min,
        r.bin_width
    FROM city_state_distribution d
    CROSS JOIN range_bounds r
)
SELECT 
    bin_number,
    overall_min + ((bin_number - 1) * bin_width) AS n_unique_customers_bin_start_value,
    overall_min + (bin_number * bin_width) AS n_unique_customers_bin_end_value,
    COUNT(*) AS n_city_state_pairs,
    ROUND(100.0 * SUM(n_unique_customers) / SUM(SUM(n_unique_customers)) OVER(), 2) AS pct_total_customers
FROM binned_data
GROUP BY bin_number, overall_min, bin_width
ORDER BY bin_number;
