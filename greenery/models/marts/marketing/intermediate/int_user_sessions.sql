{{
  config(
    materialized='table'
  )
}}

with base as (
  SELECT
      session_id
    , user_id 
    , case when event_type = 'page_view' then 1 else 0 end as page_view
    , case when event_type = 'add_to_cart' then 1 else 0 end as add_to_cart
    , case when event_type = 'checkout' then 1 else 0 end as checkout
    , case when event_type = 'package_shipped' then 1 else 0 end as package_shipped
    , order_id
    , min(created_at) as session_start
    , max(created_at) as session_end
  FROM {{ ref('stg_events') }}
  group by 1,2,3,4,5,6,7
)

SELECT
    session_id
    , user_id
    , order_id
    , session_start
    , session_end
    , datediff('minute', session_start, session_end) as session_length_min 
    , sum(page_view) as page_views
    , sum(add_to_cart) as add_to_carts
    , sum(checkout) as checkouts
    , sum(package_shipped) as packages_shipped
FROM base
GROUP BY 1,2,3,4,5,6