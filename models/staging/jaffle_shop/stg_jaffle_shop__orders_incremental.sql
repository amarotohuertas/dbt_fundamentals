{{
    config(
        materialized = 'incremental',
        unique_key = 'order_id'
    )
}}

with

source as (
    select
        *, _etl_loaded_at as load_date
    from {{ source('jaffle_shop', 'orders') }}
    {% if is_incremental %}
        where load_date >= (
        select dateadd(day, -3, max(load_date)::date) from {{ this }}
        )
    {% endif %}
),

transformed as (
    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status as order_status,
        _etl_loaded_at as load_date,
        max(_etl_loaded_at) over (partition by order_id) as max_load_date
    from source
)

select * from transformed