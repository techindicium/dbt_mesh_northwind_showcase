with
    fonte_customers as (
        select *
        from {{ ref('dbt_northwind_foundational', 'stg_erp__customers') }}
    )

select *
from fonte_customers
