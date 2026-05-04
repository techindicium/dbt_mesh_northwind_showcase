{% macro generate_schema_name(custom_schema_name, node) %}
    {{ dbt_nothwind_mesh_common.generate_schema_name(custom_schema_name, node) }}
{% endmacro %}