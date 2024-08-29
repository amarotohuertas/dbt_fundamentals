{#
    -- let's develop a macro that
    1. queries the information schema of a database
    2. finds objects that are > 1 week old (no longer maintained)
    3. generates automated drop statements
    4. has the ability to execute thos drop statements

    -- Example usage
    {{
    clean_stale_models(
        database='analytics',
        schema='dbt_amaroto_intermediate',
        days=1,
        dry_run=True
        )
    }}
#}

{% macro clean_stale_models(database=target.database, schema=target.schema, days=7, dry_run=True) %}
    
    {% set get_drop_commands_query %}
        select
            case when table_type = 'VIEW'
                then table_type
                else 'TABLE'
            end as drop_type, 
            'DROP ' || drop_type || ' {{ database | upper }}.' || table_schema || '.' || table_name || ';' as drop_command
        from {{ database }}.information_schema.tables 
        where table_schema = upper('{{ schema }}')
        and last_altered <= current_date - {{ days }} 
    {% endset %}

    {{ log('\nGenerating cleanup queries...\n', info=True) }}
    --{{ log(get_drop_commands_query, info=True) }}
    --{{ log(run_query(get_drop_commands_query), info=True) }}

    {% set drop_queries = run_query(get_drop_commands_query).columns[1].values() %}

    {% if drop_queries %}

        {% for query in drop_queries %}
            {% if execute and not dry_run %}
                {{ log('Droping object with command: ' ~ query, info=True) }}
                {% do run_query(query) %}            
            {% else %}
                {{ log(query, info=True) }}
            {% endif %}
        {% endfor %}

    {% else %}
        {% do log('No objects to clean.', True) %}
    {% endif %}
    
{% endmacro %}