with
    source_categories as (
        select *
        from {{ source('erp', 'category') }}
    )

    , renamed as (
        select
            cast(id as int) as category_pk
            , cast(categoryname as varchar) as category_name
            , cast(description as varchar) as category_description
        from source_categories
    )

select *
from renamed
