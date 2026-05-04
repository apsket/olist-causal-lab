SELECT
    COUNT(DISTINCT geolocation_city) AS n_cities,
    COUNT(DISTINCT geolocation_state) AS n_states,
    COUNT(DISTINCT (geolocation_city, geolocation_state)) AS n_city_state_combinations
FROM raw.geolocation;


WITH geolocation_city_state_multiplicity AS (
    SELECT
        geolocation_city AS city_name,
        COUNT(DISTINCT geolocation_state) AS n_states
    FROM raw.geolocation
    GROUP BY geolocation_city
)
SELECT n_states AS n_states_per_city, 
    COUNT(*) AS n_city_names
FROM geolocation_city_state_multiplicity
GROUP BY n_states
ORDER BY n_states;


WITH geolocation_coords_multiplicity AS (
    SELECT
        geolocation_lat AS lat,
        geolocation_lng AS lng,
        COUNT(DISTINCT (geolocation_city, geolocation_state)) AS n_city_state_combinations
    FROM raw.geolocation
    GROUP BY geolocation_lat, geolocation_lng
)
SELECT n_city_state_combinations, 
    COUNT(*) AS n_geo_lat_lng_coordinates
FROM geolocation_coords_multiplicity
GROUP BY n_city_state_combinations
ORDER BY n_city_state_combinations;


SELECT
    geolocation_lat AS lat,
    geolocation_lng AS lng,
    COUNT(DISTINCT (geolocation_city, geolocation_state)) AS n_city_state_combinations
FROM raw.geolocation
GROUP BY geolocation_lat, geolocation_lng
HAVING COUNT(DISTINCT (geolocation_city, geolocation_state)) > 1
ORDER BY n_city_state_combinations DESC
LIMIT 10;


SELECT geolocation_lat, geolocation_lng, geolocation_city, geolocation_state
FROM raw.geolocation
WHERE 
    (geolocation_lat = -31.666939999999954 AND geolocation_lng = -54.070829999999944)
    OR (geolocation_lat = -23.556811599774967 AND geolocation_lng = -46.65713483250617)
GROUP BY geolocation_lat, geolocation_lng, geolocation_city, geolocation_state;

