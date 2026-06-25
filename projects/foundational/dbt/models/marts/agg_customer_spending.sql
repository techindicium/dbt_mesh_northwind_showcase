with
    total_customer_spending as (
        select *
        from {{ ref('dbt_regulated_data', 'int_customer__product_total_spending') }}
    )

select *
from total_customer_spending