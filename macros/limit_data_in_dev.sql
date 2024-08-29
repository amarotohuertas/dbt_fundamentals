{% macro limit_data_in_dev(column, number) -%}

{%- if target.name == 'dev' -%}
where {{ column }} >= dateadd('day', - {{ number }}, current_timestamp)
{% endif -%}

{%- endmacro -%}