with
    source_shippers as (
        select *
        from {{ ref('shippers') }}
    )

    , renamed as (
        select
            cast(id as int) as shipper_pk
            , cast(companyname as varchar) as shipper_name
        from source_shippers
    )

select *
from renamed
