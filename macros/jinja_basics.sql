{#

{% set my_string = 'wow! cool!' %}
{% set my_second_string = 'this is jinja!' %}
{% set my_number = 100 %}

{{ my_string }} {{ my_second_string }} I want to write jinja for {{ my_number }} years.

{% set my_animals = ['lemur', 'wolf', 'panther', 'tardigrade'] %}

{{ my_animals[0] }}

{% for animal in my_animals %}

    My favourite animal is the {{ animal }}

{% endfor %}

{% set temperature = 45 %}

{% if temperature < 65 %}
    Time for a capuccino!
{% else %}
    Time for a cold brew!
{% endif %}

{%- set foods = ['carrot', 'hotdog', 'cucumber', 'bell pepper'] -%}

{% for food in foods -%}

    {%- if food == 'hotdog' -%}
        {%- set food_type = 'snack' -%}
    {%- else -%}
        {%- set food_type = 'vegetable' -%}
    {%- endif -%}

    The humble {{ food }} is my favourite {{ food_type }}

{% endfor %}

#}

{%- set dict = {
    'word' : 'data',
    'speech' : 'noun',
    'definition' : 'if you know you know'
} -%}

{{ dict['word'] }} {{ dict['speech'] }}: defined as {{ dict['definition'] }}