{{ config(
    materialized='incremental',
    unique_key='INVOICE_ID'
) }}
 
select
 
    inv.INVOICE_ID,
 
    inv.INVOICE_NUMBER,
 
    inv.SALES_ORDER_ID,
 
    dc.CUSTOMER_SK,
 
    to_number(
        to_char(
            to_date(inv.INVOICE_DATE),
            'YYYYMMDD'
        )
    ) as DATE_KEY,
 
    inv.INVOICE_AMOUNT,
 
    inv.PAYMENT_STATUS,
 
    current_timestamp() as DW_LOAD_DATE
 
from {{ source('stg','ERP_INVOICES') }} inv
 
inner join {{ source('stg','ERP_SALES_ORDERS') }} so
    on inv.SALES_ORDER_ID = so.SALES_ORDER_ID
 
inner join {{ ref('dim_customer') }} dc
    on so.CUSTOMER_ID = dc.CUSTOMER_ID
   and dc.IS_CURRENT = 1