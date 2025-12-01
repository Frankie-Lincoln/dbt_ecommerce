-- models/intermediate/int_product_margin.sql
WITH product_costs AS (
    -- Calculate the average cost based on inventory items
    SELECT
        product_id,
        AVG(cost) AS avg_product_cost,
        AVG(product_retail_price) AS avg_product_retail_price
    FROM
        {{ ref('stg_inventory_items') }}
    GROUP BY
        1
)

SELECT
    p.product_id AS product_id,
    p.product_category AS product_category,
    p.product_name AS product_name,
    p.product_brand AS product_brand,
    p.product_department AS product_department,
    
    c.avg_product_cost AS avg_product_cost,
    c.avg_product_retail_price AS avg_product_retail_price,
    
    -- Calculate average margin (Retail Price - Cost)
    (c.avg_product_retail_price - c.avg_product_cost) AS avg_product_margin_absolute,
    
    -- Calculate margin percentage
    SAFE_DIVIDE(
        (c.avg_product_retail_price - c.avg_product_cost),
        c.avg_product_retail_price
    ) AS avg_product_margin_percentage

FROM
    {{ ref('stg_products') }} AS p
INNER JOIN
    product_costs AS c
    ON p.product_id = c.product_id