{{
  config(
    materialized='table'
  )
}}

SELECT 
  user_id
  , first_name
  , last_name
  , lower(email) as user_email
  , phone_number
  , created_at as user_created_at
  , updated_at as user_updated_at
  , address_id
FROM {{ source('postgres', 'users') }}