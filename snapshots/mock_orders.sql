{% snapshot stg_jaffle_shop__mock_orders %}

{% set new_schema = target.schema + '_snapshot' %}

    {{
        config(
            target_database = 'analytics',
            target_schema = new_schema,
            unique_key='order_id',

            strategy='timestamp',
            updated_at='updated_at'
        )
    }}

    select * from analytics.{{ target.schema }}.stg_jaffle_shop__mock_orders

 {% endsnapshot %}