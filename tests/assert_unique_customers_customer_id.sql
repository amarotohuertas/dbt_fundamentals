-- assert_unique_customers_customer_id.sql

select
    customer_id
from {{ ref('dim_customers') }}
group by customer_id
having count(*) > 1