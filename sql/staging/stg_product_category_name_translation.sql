CREATE OR REPLACE VIEW staging.stg_product_category_name_translation AS
SELECT
    product_category_name,
    product_category_name_english
FROM raw.product_category_name_translation;