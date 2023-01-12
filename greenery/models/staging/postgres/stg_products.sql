{{
  config(
    materialized='table'
  )
}}

SELECT
  product_id
  , name
  , price::float as price
  , inventory::int as inventory
FROM {{ source('postgres', 'products') }}