with
    source_bridge_customers_orders as (
        select *
        from {{ ref('bridge_customers_orders') }}
    )

    , renamed as (
        select
            cast(orderid as int) as order_pk
            , cast(customerid as varchar) as customer_fk
        from source_bridge_customers_orders
    )

select *
from renamed