-- models/marts/fct_sales.sql
SELECT
    -- Keys and Dates (Foreign Keys to Dimensions)
    d.order_item_id AS order_item_key,
    d.order_id,
    d.user_id AS customer_key,
    d.product_id AS product_key,
    d.inventory_item_id,

    d.order_item_created_at_timestamp AS transaction_at,
    d.order_item_month AS transaction_month,

    -- Measures (Financial Metrics)
    d.sale_price AS gross_revenue,
    i.cost AS cost_of_goods_sold,
    
    -- Calculated Measure: Gross Profit
    (d.sale_price - i.cost) AS gross_profit,

    -- Status Flags
    CASE WHEN d.order_status = 'Returned' THEN TRUE ELSE FALSE END AS is_returned,
    d.order_status

FROM
    {{ ref('int_order_details') }} AS d
INNER JOIN
    {{ ref('stg_inventory_items') }} AS i
    ON d.inventory_item_id = i.inventory_item_id

-- Incremental Logic (BigQuery optimization)
{% if is_incremental() %}
WHERE d.order_item_created_at_timestamp > (SELECT MAX(transaction_at) FROM {{ this }})
{% endif %}