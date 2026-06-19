with
    order_items_metrics as (
        select *
        from {{ ref('dbt_data', 'int_order_items__metrics') }}
    )

    , customers_orders_bridge as (
        select *
        from {{ ref('int_bridge') }}
    )

select
    {{ dbt_utils.generate_surrogate_key([
        'customer_fk'
        , 'product_fk'
    ]) }} as customer_product_pk
    , customer_fk
    , product_fk
    , sum(gross_total) as total_gross_spending
from customers_orders_bridge
inner join order_items_metrics
    on customers_orders_bridge.order_pk = order_items_metrics.order_fk
group by all
