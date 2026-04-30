CREATE OR REPLACE VIEW staging.stg_payments AS
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM raw.payments;