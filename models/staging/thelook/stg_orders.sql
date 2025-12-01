-- models/staging/the_look/stg_orders.sql

SELECT
    order_id,
    user_id,
    status AS order_status,

    -- Timestamp Fields (high fidelity)
    created_at AS order_created_at_timestamp,
    returned_at AS order_returned_at_timestamp,
    shipped_at AS order_shipped_at_timestamp,
    delivered_at AS order_delivered_at_timestamp,

    -- Month Field (YYYY-MM string format for order/time analysis)
    FORMAT_DATE(
        '%Y-%m',
        DATE(created_at)
    ) AS order_month,

    num_of_item
FROM
    {{ source('thelook', 'orders') }}