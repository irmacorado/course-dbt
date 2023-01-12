{{
  config(
    materialized='table'
  )
}}

SELECT 
  promo_id as promo_desc
  , discount::float as discount
  , status
FROM {{ source('postgres', 'promos') }}