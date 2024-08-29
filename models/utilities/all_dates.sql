{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2024-01-01' as date)",
    end_date="dateadd('day', 1, current_date)"
   )
}}