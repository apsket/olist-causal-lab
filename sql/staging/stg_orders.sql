CREATE OR REPLACE VIEW staging.stg_orders AS
SELECT
    -- ===== IDENTIFIERS =====
    o.order_id,
    o.customer_id,

    -- ===== ORDER STATUS =====
    o.order_status,

    -- ===== RAW TIMESTAMPS =====
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    -- ===== DERIVED TIME FEATURES =====

    -- Time from purchase to approval
    EXTRACT(EPOCH FROM (o.order_approved_at - o.order_purchase_timestamp)) / 3600
        AS hours_to_approval,

    -- Time from purchase to delivery
    EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 3600
        AS delivery_time_hours,

    -- Delay relative to estimate
    EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_estimated_delivery_date)) / 3600
        AS delivery_delay_hours,

    -- Time from carrier pickup to delivery
    EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_delivered_carrier_date)) / 3600
        AS carrier_to_customer_hours,

    -- ===== BOOLEAN FLAGS (safe transformations) =====

    -- Delivered successfully
    CASE 
        WHEN o.order_status = 'delivered' THEN 1 
        ELSE 0 
    END AS is_delivered,

    -- Late delivery
    CASE
        WHEN o.order_delivered_customer_date IS NOT NULL
         AND o.order_estimated_delivery_date IS NOT NULL
         AND o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 1
        ELSE 0
    END AS is_delayed,

    -- Missing delivery info (important for filtering later)
    CASE
        WHEN o.order_delivered_customer_date IS NULL THEN 1
        ELSE 0
    END AS is_delivery_missing

FROM raw.orders o;