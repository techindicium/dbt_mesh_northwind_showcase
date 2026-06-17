with customers_orders_bridge as (
    select *
    from {{ ref('stg_erp__customers_orders_bridge') }}
)

select *
from customers_orders_bridge