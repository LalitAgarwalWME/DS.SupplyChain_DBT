{% snapshot product_snapshot %}
{{
    config(
        target_database='SUPPLYCHAIN',
        target_schema='SNAPSHOTS',
        unique_key='product_id',
        strategy='check',
        check_cols='all'
    )
}}
select *
from {{ source('stg', 'ERP_PRODUCTS') }}
{% endsnapshot %}