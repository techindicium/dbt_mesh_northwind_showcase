with
    stg_shippers as (
        select *
        from {{ ref('dbt_northwind_foundational', 'stg_erp__shippers') }}
    )

select *
from stg_shippers