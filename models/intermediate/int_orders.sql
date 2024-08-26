with

-- Import CTEs

orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
    where payment_status <> 'fail'
),

-- Logical CTEs

completed_payments as (
    select
                
        order_id,
        max(payment_created_at) as payment_finalized_date,
        sum(payment_amount) as total_amount_paid

    from payments
    group by 1
),

-- Final CTE

paid_orders as (
    
    select
    
        orders.order_id,
        orders.customer_id,
        orders.order_date as order_placed_at,
        orders.order_status,
        orders.user_order_seq as customer_sales_seq,
        completed_payments.total_amount_paid,
        completed_payments.payment_finalized_date

    from orders
    left join completed_payments
        on orders.order_id = completed_payments.order_id
    
)

-- Simple select statement

select * from paid_orders