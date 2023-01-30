{% macro event_type_binary(event_name) %}
    case when event_type = '{{ event_name }}' then 1 else 0 end
{% endmacro %}