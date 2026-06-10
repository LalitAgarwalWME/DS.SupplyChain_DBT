{{ config(materialized='table') }}
 
select
 
    row_number() over(
        order by PRODUCT_ID, DBT_VALID_FROM
    ) as PRODUCT_SK,
 
    PRODUCT_ID,
    PRODUCT_CODE,
    PRODUCT_NAME,
    CATEGORY,
    UNIT_PRICE,
    IS_ACTIVE,
 
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
 
from SUPPLYCHAIN.SNAPSHOTS.PRODUCT_SNAPSHOT