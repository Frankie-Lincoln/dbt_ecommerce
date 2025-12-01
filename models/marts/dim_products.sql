-- models/marts/dim_products.sql
SELECT
    -- Keys
    p.product_id AS product_key,

    -- Attributes
    p.product_name,
    p.product_brand,
    p.product_category,
    p.product_department,

    -- Price & Cost
    p.avg_product_retail_price AS retail_price,
    p.avg_product_cost AS product_cost,

    -- Profitability Metrics
    p.avg_product_margin_absolute AS average_margin,
    p.avg_product_margin_percentage AS average_margin_percent

FROM
    {{ ref('int_product_margin') }} AS p