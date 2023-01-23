{{
  config(
    materialized='table'
  )
}}

SELECT 
  order_id
  , promo_id as promo_desc
  , user_id
  , address_id
  , created_at as order_created_at
  , order_cost::float as order_cost
  , shipping_cost::float as shipping_cost
  , order_total::float as order_total
  , tracking_id
  , shipping_service
  , estimated_delivery_at
  , delivered_at
  , status as order_status
FROM {{ source('postgres', 'orders') }}