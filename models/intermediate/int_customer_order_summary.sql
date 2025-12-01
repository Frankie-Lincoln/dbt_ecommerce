-- models/intermediate/int_customer_order_summary.sql
WITH order_revenue AS (
    -- Step 1: Calculate total revenue and items for each individual order
    SELECT
        order_id,
        user_id,
        COUNT(DISTINCT order_item_id) AS items_in_order,
        SUM(sale_price) AS order_total_revenue
    FROM
        {{ ref('stg_order_items') }}
    GROUP BY
        1, 2
),

customer_summary AS (
    -- Step 2: Aggregate order data up to the customer level
    SELECT
        o.user_id,
        
        -- Lifetime Metrics
        COUNT(DISTINCT o.order_id) AS total_orders_lifetime,
        SUM(r.order_total_revenue) AS total_revenue_lifetime,
        
        -- Recency and Frequency Dates
        MIN(o.order_created_at_timestamp) AS first_order_at,
        MAX(o.order_created_at_timestamp) AS last_order_at,
        
        -- Average Metrics
        AVG(r.order_total_revenue) AS avg_order_value_lifetime
        
    FROM
        {{ ref('stg_orders') }} AS o
    INNER JOIN
        order_revenue AS r
        ON o.order_id = r.order_id
    GROUP BY
        1
)

-- Step 3: Final Selection and Calculation of Recency
SELECT
    user_id,
    
    -- LTV and Frequency
    total_orders_lifetime,
    total_revenue_lifetime,
    avg_order_value_lifetime,

    -- Dates
    first_order_at,
    last_order_at,
    
    -- Recency Calculation: Days since the last order
    {{ dbt.datediff('last_order_at', 'current_timestamp()', 'day') }} AS days_since_last_order

FROM
    customer_summary