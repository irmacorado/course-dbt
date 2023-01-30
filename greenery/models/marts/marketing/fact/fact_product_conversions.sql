{{
  config(
    materialized='table'
  )
}}

SELECT product_name
  , count(distinct case when checkout > 0 then session_id end) as conversions
  , count(distinct session_id) as sessions
  , conversions*100 / sessions as conversion_rate
FROM {{ ref('int_user_product_sessions') }}
left join {{ ref('stg_products') }} using (product_id)
group by 1