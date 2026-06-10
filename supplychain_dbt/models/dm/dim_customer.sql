{{ config(materialized='table') }}
 
select
 
    row_number() over(
        order by CUSTOMER_ID, DBT_VALID_FROM
    ) as CUSTOMER_SK,
 
    CUSTOMER_ID,
    CUSTOMER_CODE,
    CUSTOMER_NAME,
    CUSTOMER_TYPE,
    CITY,
    STATE,
    COUNTRY,
 
    DBT_VALID_FROM as EFFECTIVE_FROM_DATE,
 
    coalesce(
        DBT_VALID_TO,
        to_timestamp('9999-12-31')
    ) as EFFECTIVE_TO_DATE,
 
    case
        when DBT_VALID_TO is null then 1
        else 0
    end as IS_CURRENT,
 
    current_timestamp() as DW_LOAD_DATE
 
from SUPPLYCHAIN.SNAPSHOTS.CUSTOMER_SNAPSHOT