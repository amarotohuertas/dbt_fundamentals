{% macro cents_to_dollars(number, decimals = 2) -%}

round( 1.0 * {{ number }} / 100, {{ decimals }})

{%- endmacro %}