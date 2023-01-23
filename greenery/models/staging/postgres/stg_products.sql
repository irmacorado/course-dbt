{{
  config(
    materialized='table'
  )
}}

SELECT
  product_id
  , name as product_name
  , price::float as product_price
  , inventory::int as product_inventory
FROM {{ source('postgres', 'products') }}