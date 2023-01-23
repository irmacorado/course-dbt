{{
  config(
    materialized='table'
  )
}}

with sessions_summary_by_day as (
  SELECT 
  product_id
  , trunc(session_start, 'day') as session_start_date 
  , sum(page_views) as page_views
  , count(distinct case when checkout > 0 then order_id end) as orders
  FROM {{ ref('int_user_product_sessions')}}
  GROUP BY 1,2 
)

SELECT 
stg_products.product_id
, stg_products.product_name
, avg(page_views) as avg_page_views
, avg(orders) as avg_orders
, min(session_start_date) as first_session
, max(session_start_date) as last_session
FROM {{ ref('stg_products') }} stg_products
LEFT JOIN sessions_summary_by_day using (product_id)
GROUP BY 1,2