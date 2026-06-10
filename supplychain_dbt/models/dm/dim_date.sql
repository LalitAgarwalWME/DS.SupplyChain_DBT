{{ config(materialized='table') }}
 
with dates as (
 
    select
        dateadd(
            day,
            seq4(),
            '2023-01-01'
        ) as FULL_DATE
 
    from table(generator(rowcount => 2000))
 
)
 
select
 
    to_number(to_char(FULL_DATE,'YYYYMMDD')) as DATE_KEY,
 
    FULL_DATE,
 
    year(FULL_DATE) as YEAR,
 
    quarter(FULL_DATE) as QUARTER,
 
    month(FULL_DATE) as MONTH,
 
    monthname(FULL_DATE) as MONTH_NAME,
 
    week(FULL_DATE) as WEEK,
 
    day(FULL_DATE) as DAY_OF_MONTH
 
from dates