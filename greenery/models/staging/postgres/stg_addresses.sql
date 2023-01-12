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
FROM {{ source('postgres', 'addresses') }}