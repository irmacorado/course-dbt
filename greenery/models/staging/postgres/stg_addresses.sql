{{
  config(
    materialized='table'
  )
}}

SELECT 
  address_id
  , address as street_address
  , lpad(zipcode,5,'00000')::varchar as zipcode
  , state
  , country
  , (street_address||', '||state||', '||zipcode) as full_address
FROM {{ source('postgres', 'addresses') }}