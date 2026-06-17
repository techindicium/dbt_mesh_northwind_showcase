with
    orders_metrics as (
        select *
        from {{ ref('int_orders__metrics') }}
    ),

    customers_orders_bridge as (
        select *
        from {{ ref('int_customers_orders_bridge') }}
    )

select
    customer_id,
    sum(total_quantity) as total_spending
from customers_orders_bridge
inner join orders_metrics on orders_metrics.order_pk = customers_orders_bridge.order_id
group by customer_id