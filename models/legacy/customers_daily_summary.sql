select

    {{ dbt_utils.generate_surrogate_key(['customer_id', 'order_id']) }} as id,
    customer_id,
    order_id,
    count(*) as total

from {{ ref('stg_jaffle_shop__orders') }}
group by 1, 2, 3