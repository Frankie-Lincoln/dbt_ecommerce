-- models/staging/the_look/stg_users.sql

SELECT
    -- Primary Key
    id AS user_id,

    -- Demographics & Attributes
    first_name,
    last_name,
    email,
    age,
    gender,

    -- Location & Acquisition
    country,
    traffic_source,

    -- Date Fields
    created_at AS user_created_at_timestamp,
    
    -- Cohort/Month Field (YYYY-MM string format for easy group-by)
    -- In BigQuery, this is done using the FORMAT_DATE function on the DATE part of the TIMESTAMP
    FORMAT_DATE(
        '%Y-%m',
        DATE(created_at)
    ) AS user_sign_up_month

FROM
    {{ source('thelook', 'users') }}
