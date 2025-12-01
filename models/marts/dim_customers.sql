-- models/marts/dim_customers.sql
SELECT
    -- Keys
    u.user_id AS customer_key,

    -- Demographics & Attributes
    u.first_name,
    u.last_name,
    u.email,
    u.age,
    u.gender,
    u.country,
    u.traffic_source,

    -- Cohort & Dates
    u.user_sign_up_month AS customer_cohort_month,
    u.user_created_at_timestamp AS sign_up_at,

    -- Lifetime Value (LTV) Metrics from Intermediate Model
    s.total_orders_lifetime,
    s.total_revenue_lifetime,
    s.avg_order_value_lifetime,
    s.first_order_at,
    s.last_order_at,

    -- Recency and Status
    s.days_since_last_order,
    
    -- Customer Status Classification
    CASE
        WHEN s.total_orders_lifetime IS NULL THEN 'New (No Orders)'
        WHEN s.days_since_last_order < 90 THEN 'Active'
        WHEN s.days_since_last_order >= 90 THEN 'Dormant'
        ELSE 'Unknown'
    END AS customer_status_90_day

FROM
    {{ ref('stg_users') }} AS u
LEFT JOIN
    {{ ref('int_customer_order_summary') }} AS s
    ON u.user_id = s.user_id