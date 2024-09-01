with

-- Import CTEs

customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
),

paid_orders as (
    select * from {{ ref('int_orders') }}
),

employees as (
    select * from {{ ref('employees') }}
),

-- Logical CTEs
employee_customers as (

    select

        customers.customer_id,
        customers.givenname as customer_first_name,
        customers.surname as customer_last_name,
        employees.employee_id is not null as is_employee,
        employees.email as employee_email

    from customers
    left join employees
        on customers.customer_id = employees.customer_id 

),

-- Final CTE

final as (

    select

        paid_orders.order_id,
        paid_orders.customer_id,
        paid_orders.order_placed_at,
        paid_orders.order_status,
        paid_orders.total_amount_paid,
        payment_finalized_date,
        employee_customers.customer_first_name,
        employee_customers.customer_last_name,
        employee_customers.is_employee,
        employee_customers.employee_email,
        
        -- sales transaction sequence
        row_number() over (order by paid_orders.order_placed_at, paid_orders.order_id) as transaction_seq,
        
        -- customer sales sequences
        paid_orders.customer_sales_seq,

        -- new vs returning customer
        case
            when (
            rank() over(
                partition by paid_orders.customer_id
                order by paid_orders.order_placed_at, paid_orders.order_id
                ) = 1
            ) then 'new'
            else 'return'
        end as nvsr,

        -- cumulative running total of rows
        sum(paid_orders.total_amount_paid) over (
            partition by paid_orders.customer_id 
            order by paid_orders.order_id
        ) as customer_lifetime_value,
        
        -- first day of sale
        first_value(paid_orders.order_placed_at) over (
            partition by paid_orders.customer_id
            order by paid_orders.order_placed_at
        ) as fdos

    from paid_orders
    left join employee_customers
        on paid_orders.customer_id = employee_customers.customer_id
    order by paid_orders.order_id

)

-- Simple select statement

select * from final --where customer_id = 54