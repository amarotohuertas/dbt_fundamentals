with

-- Source
source as (
    select * from {{ source('jaffle_shop', 'mock_orders') }}
),

transformed as (
    
    select
        *
    from source

)

select * from transformed