
select *
 
from {{ ref('dim_products') }}
 
where IS_CURRENT = 1