{{
  config(
    materialized='table'
  )
}}

SELECT
  order_id
  , product_id
  , quantity::int as quantity
FROM {{ source('postgres', 'order_items') }}