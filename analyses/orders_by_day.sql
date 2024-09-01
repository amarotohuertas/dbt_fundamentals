with

orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

daily as (

    select
        order_date,
        count(*) as order_num,

        {%- set order_statuses = ['returned', 'completed', 'return_pending', 'shipped', 'placed'] -%}

        {%- for status in order_statuses %}
            sum(case when order_status = '{{ status }}' then 1 else 0 end) as {{ status }}_orders

            {{- ',' if not loop.last }}
        {%- endfor -%}

    from orders
    group by 1

)

select * from daily