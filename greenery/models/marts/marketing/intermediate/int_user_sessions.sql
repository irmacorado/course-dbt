{{
  config(
    materialized='table'
  )
}}

with base as (
  SELECT
      session_id
    , user_id 
    , {{ event_type_binary(page_view) }} as page_view
    , {{ event_type_binary(add_to_cart) }}  as add_to_cart
    , {{ event_type_binary(checkout) }} as checkout
    , {{ event_type_binary(package_shipped) }} as package_shipped
    , order_id
    , min(created_at) as session_start
    , max(created_at) as session_end
  FROM {{ ref('stg_events') }}
  {{ dbt_utils.group_by(7) }}
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