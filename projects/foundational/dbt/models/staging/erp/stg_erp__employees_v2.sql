with
    source_employees as (
        select *
        from {{ source('erp', 'employees') }}
    )

    , renamed as (
        select
            cast(id as int) as employee_pk
            , cast(reportsto as int) as manager_fk
            , cast(firstname as varchar) as employee_first_name
            , cast(lastname as varchar) as employee_last_name
            , cast(title as varchar) as employee_title
            , cast(birthdate as date) as employee_birth_date
            , cast(hiredate as date) as employee_hire_date
            , cast(city as varchar) as employee_city
            , cast(region as varchar) as employee_region
            , cast(country as varchar) as employee_country
        from source_employees
    )

select *
from renamed
