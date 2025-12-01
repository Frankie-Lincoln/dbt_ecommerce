-- models/intermediate/int_order_details.sql
SELECT
    -- Fact Granularity: Order Item Attributes
    oi.order_item_id,
    oi.sale_price,
    oi.order_item_created_at_timestamp,
    oi.order_item_month,
    
    -- Order Header Attributes
    o.order_id,
    o.order_status,
    o.order_created_at_timestamp,
    o.order_month,

    -- Foreign Keys / Dimensions
    oi.user_id,
    oi.product_id,
    oi.inventory_item_id,
    
    -- Status Timestamps
    o.order_returned_at_timestamp,
    o.order_shipped_at_timestamp,
    o.order_delivered_at_timestamp
    
FROM
    {{ ref('stg_order_items') }} AS oi
INNER JOIN
    {{ ref('stg_orders') }} AS o
    ON oi.order_id = o.order_id