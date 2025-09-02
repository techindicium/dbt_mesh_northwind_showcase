with
    fonte_customers as (
        select *
        from {{ ref('dbt_nothwind_mesh_foundational', 'stg_erp__customers') }}
    )

select *
from fonte_customers
