-- models/staging/the_look/stg_products.sql

SELECT
    id AS product_id,
    cost AS product_cost,
    category AS product_category,
    name AS product_name,
    brand AS product_brand,
    department AS product_department,
    retail_price AS product_retail_price,
    distribution_center_id
FROM
    {{ source('thelook', 'products') }}