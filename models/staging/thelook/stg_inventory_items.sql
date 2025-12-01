-- models/staging/the_look/stg_inventory_items.sql

SELECT
    id AS inventory_item_id,
    product_id,
    cost,
    product_category,
    product_name,
    product_brand,
    product_retail_price
FROM
    {{ source('thelook', 'inventory_items') }}