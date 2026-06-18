with
    source_bridge_customers_orders as (
        select *
        from {{ ref('bridge_customers_orders') }}
    )

    , renamed as (
        select
            cast(ORDERID as int) as order_id
            , cast(CUSTOMERID as varchar) as customer_id
        from source_bridge_customers_orders
    )

select *
from renamed