{{
  config(
    materialized='table'
  )
}}

with views_cart as (
SELECT
    session_id
  , user_id 
  , product_id 
  , case when event_type = 'page_view' then 1 else 0 end as page_view
  , case when event_type = 'add_to_cart' then 1 else 0 end as add_to_cart
  , min(created_at) as session_start
  , max(created_at) as session_end
FROM {{ ref('stg_events') }}
WHERE event_type in ('page_view','add_to_cart')
GROUP BY 1,2,3,4,5
)

, checkout_shipped as (
  SELECT
  session_id
  , user_id
  , case when event_type = 'checkout' then 1 else 0 end as checkout
  , case when event_type = 'package_shipped' then 1 else 0 end as package_shipped
  , order_id
  , min(created_at) as session_start
  , max(created_at) as session_end
  FROM {{ ref('stg_events') }}
  WHERE event_type in ('checkout','package_shipped')
  GROUP BY 1,2,3,4,5
)

, views_cart_pivot as (
    SELECT 
    session_id
    , user_id
    , product_id
    , min(session_start) as session_start
    , max(session_end) as session_end
    , sum(page_view) as page_views
    , sum(add_to_cart) as add_to_cart
    FROM views_cart
    GROUP BY 1,2,3
)

, checkout_shipped_pivot as (
    SELECT 
    session_id
    , user_id
    , order_id
    , min(session_start) as session_start
    , max(session_end) as session_end
    , case when sum(checkout) > 0 then 1 else 0 end as checkout
    , case when sum(package_shipped) > 0 then 1 else 0 end as package_shipped
    FROM checkout_shipped
    GROUP BY 1,2,3
)

select
    views_cart_pivot.session_id
    , views_cart_pivot.user_id
    , views_cart_pivot.product_id
    , checkout_shipped_pivot.order_id
    , case when views_cart_pivot.session_start < checkout_shipped_pivot.session_start then views_cart_pivot.session_start else checkout_shipped_pivot.session_start end as session_start
    , case when views_cart_pivot.session_end < checkout_shipped_pivot.session_end then views_cart_pivot.session_end else checkout_shipped_pivot.session_end end as session_end
    , datediff('minute', session_start, session_end) as session_length_min 
    , views_cart_pivot.page_views
    , views_cart_pivot.add_to_cart
    , checkout_shipped_pivot.checkout
    , checkout_shipped_pivot.package_shipped
from views_cart_pivot
left join checkout_shipped_pivot using (session_id, user_id)