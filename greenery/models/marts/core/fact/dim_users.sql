{{
  config(
    materialized='table'
  )
}}

SELECT 
    user_id
  , user_email
  , user_created_at
  , user_updated_at
  , stg_users.address_id
  , full_address
  , zipcode
  , state
  , country
FROM {{ ref('stg_users') }} stg_users
LEFT JOIN {{ref('stg_addresses')}} using (address_id)