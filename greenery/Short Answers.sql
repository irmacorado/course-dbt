/*How many users do we have?*/
--ANSWER: 130

select count(distinct user_id) as num_users 
from stg_users;

/*On average, how many orders do we receive per hour?*/
--ANSWER: 8-9 orders hourly on average
with total_orders_hourly as (
    select trunc(created_at, 'hour') as hour 
        , count(distinct order_id) as num_orders
    from stg_orders
    group by 1
)

select avg(distinct num_orders) as avg_orders_hourly
from total_orders_hourly;


/*On average, how long does an order take from being placed to being delivered?*/
--ANSWER: 93 hrs or 3-4 days

with order_delivery_times as (
    select order_id
        , created_at
        , delivered_at
        , datediff('hour',created_at, delivered_at) as hrs_to_deliver
        , datediff('day',created_at, delivered_at) as days_to_deliver
    from stg_orders
    where delivered_at is not null
    ) 
    
select avg(hrs_to_deliver)
, avg(days_to_deliver)
from order_delivery_times;

/*How many users have only made one purchase? Two purchases? Three+ purchases?*/
--Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.
-- ANSWER:25 have made 1 purchase, 28 have made 2 purchases, 71 have made 3 or more
with user_order_count as (
    select user_id
    , count(distinct order_id) as num_orders
    from stg_orders
    group by 1)

select case when num_orders >= 3 then '3+' else num_orders::varchar end as num_orders
, count(distinct user_id) as num_users
from user_order_count
group by 1
order by 1 asc;


/*On average, how many unique sessions do we have per hour?*/
--ANSWER: 16 sessions
with hourly_sessions as (
    select trunc(created_at, 'hour') as hour 
    , count(distinct session_id) as sessions
    from stg_events
    group by 1)
    
select avg(sessions)
from hourly_sessions;
