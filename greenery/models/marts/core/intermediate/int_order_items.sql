{{
  config(
    materialized='table'
  )
}}

SELECT 
  int_orders.order_id
  , stg_order_items.product_id
  , int_orders.user_id
  , int_orders.order_created_at
  , int_orders.order_status
  , stg_products.product_name
  , stg_products.product_price 
  , stg_order_items.product_quantity
FROM {{ ref('int_orders')}} int_orders
LEFT JOIN {{ ref('stg_order_items') }} stg_order_items using (order_id)
LEFT JOIN {{ ref('stg_products') }} stg_products using (product_id)