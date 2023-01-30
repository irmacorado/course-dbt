{{
  config(
    materialized='table'
  )
}}

with order_items_summary as (
  SELECT 
  order_id
  , sum(product_quantity) as num_products
  , count(distinct product_id) as num_unique_products
  , sum(product_quantity * product_price)*1.0 / sum(product_quantity) as avg_product_price
  FROM {{ ref('int_order_items') }}
  GROUP BY 1
)

SELECT *
FROM {{ ref('int_orders') }} int_orders
LEFT JOIN order_items_summary using (order_id)