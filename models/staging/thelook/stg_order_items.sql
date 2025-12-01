-- models/staging/the_look/stg_order_items.sql

SELECT
    id AS order_item_id,
    order_id,
    user_id,
    product_id,
    inventory_item_id,
    sale_price,

    -- Timestamp Fields (high fidelity)
    created_at AS order_item_created_at_timestamp,
    shipped_at AS order_item_shipped_at_timestamp,
    delivered_at AS order_item_delivered_at_timestamp,
    returned_at AS order_item_returned_at_timestamp,

    -- Month Field (YYYY-MM string format for item/time analysis)
    FORMAT_DATE(
        '%Y-%m',
        DATE(created_at)
    ) AS order_item_month
    
FROM
    {{ source('thelook', 'order_items') }}