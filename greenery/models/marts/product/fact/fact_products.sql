{{
  config(
    materialized='table'
  )
}}

with order_items_summary as (
  SELECT 
  product_id
  , sum(product_quantity) as num_purchases
  , count(distinct order_id) as num_orders
  , min(order_created_at) as first_order_date
  , max(order_created_at) as last_order_date
  FROM {{ ref('int_order_items')}}
  GROUP BY 1
)

SELECT *
FROM {{ ref('stg_products') }}
LEFT JOIN order_items_summary using (product_id)