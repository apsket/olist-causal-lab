DO $$
BEGIN
    IF (SELECT COUNT(*) FROM raw.orders) = 0 THEN
        RAISE EXCEPTION 'Orders table is empty!';
    END IF;
END $$;

DO $$
BEGIN
    SELECT MIN(order_purchase_timestamp), MAX(order_purchase_timestamp) FROM raw.orders;
    END $$;
END $$;
