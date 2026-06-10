{{ config(
    materialized='incremental',
    unique_key='SALES_ORDER_ITEM_ID'
) }}
 
select
 
    soi.SALES_ORDER_ITEM_ID,
 
    so.SALES_ORDER_ID,
 
    dc.CUSTOMER_SK,
 
    dp.PRODUCT_SK,
 
    to_number(
        to_char(
            to_date(so.ORDER_DATE),
            'YYYYMMDD'
        )
    ) as DATE_KEY,
 
    soi.QUANTITY,
 
    soi.UNIT_PRICE,
 
    soi.LINE_AMOUNT,
 
    so.ORDER_STATUS,
 
    current_timestamp() as DW_LOAD_DATE
 
from {{ source('stg','ERP_SALES_ORDER_ITEMS') }} soi
 
inner join {{ source('stg','ERP_SALES_ORDERS') }} so
    on soi.SALES_ORDER_ID = so.SALES_ORDER_ID
 
inner join {{ ref('dim_customer') }} dc
    on so.CUSTOMER_ID = dc.CUSTOMER_ID
   and dc.IS_CURRENT = 1
 
inner join {{ ref('dim_products') }} dp
    on soi.PRODUCT_ID = dp.PRODUCT_ID
   and dp.IS_CURRENT = 1