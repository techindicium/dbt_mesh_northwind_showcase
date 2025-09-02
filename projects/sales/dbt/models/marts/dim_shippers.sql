with
    stg_shippers as (
        select *
        from {{ ref('dbt_nothwind_mesh_foundational', 'stg_erp__shippers') }}
    )

select *
from stg_shippers