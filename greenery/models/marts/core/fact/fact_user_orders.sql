{{
  config(
    materialized='table'
  )
}}

with orders_summary as (
    SELECT
    user_id
    , count(distinct order_id) as num_orders
    , count(distinct order_id||promo_desc) as num_promos
    , sum(order_cost) as total_orders_cost
    , sum(shipping_cost) as total_shipping_cost
    , sum(order_total) as total_orders_total
    , sum(discount) as total_discount
    , min(order_created_at) as first_order_date
    , max(order_created_at) as last_order_date
    FROM {{ ref('int_orders') }}
    GROUP BY 1
)

, order_items_summary as (
    SELECT 
    user_id
    , sum(product_quantity) as total_num_items
    , count(distinct product_id) as unique_items
    , sum(product_quantity*product_price)*1.0/sum(product_quantity) as avg_item_price
    FROM {{ ref('int_order_items') }}
    GROUP BY 1
)

select *
from {{ ref('dim_users') }}
left join orders_summary using (user_id)
left join order_items_summary using (user_id)