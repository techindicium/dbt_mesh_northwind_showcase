with orders as (
    select *
    from {{ ref('bridge_customers_orders') }}
)

select
    ORDERID as order_id,
    CUSTOMERID as customer_id
from orders