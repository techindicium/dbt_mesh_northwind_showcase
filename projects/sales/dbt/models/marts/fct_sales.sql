with
    order_items_metrics as (
        select
            order_item_sk
            , product_fk
            , employee_fk
            , customer_fk
            , shipper_fk
            , order_date
            , ship_date
            , required_delivery_date
            , discount_pct
            , unit_price
            , quantity
            , freight
            , order_number
            , recipient_name
            , recipient_city
            , recipient_region
            , recipient_country
        from {{ ref('int_order_items__metrics') }}
    )

select *
from order_items_metrics
