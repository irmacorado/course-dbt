{{
  config(
    materialized='table'
  )
}}

SELECT 
  stg_orders.order_id
  , stg_orders.user_id
  , stg_orders.address_id
  , stg_orders.promo_desc
  , stg_orders.order_created_at
  , stg_orders.order_cost
  , stg_orders.shipping_cost
  , stg_promos.discount
  , stg_orders.order_total
  , stg_orders.tracking_id
  , stg_orders.order_status 
FROM {{ ref('stg_orders') }} stg_orders
LEFT JOIN {{ref('stg_promos')}} stg_promos USING (promo_desc)
