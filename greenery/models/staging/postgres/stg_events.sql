{{
  config(
    materialized='table'
  )
}}

SELECT
  event_id::varchar as event_id
  , session_id::varchar as session_id
  , user_id::varchar as user_id 
  , event_type::varchar as event_type 
  , page_url::varchar as page_url 
  , created_at
  , order_id
  , product_id
FROM {{ source('postgres', 'events') }}