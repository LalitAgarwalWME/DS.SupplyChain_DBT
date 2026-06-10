
select *
 
from {{ ref('dim_customer') }}
 
where IS_CURRENT = 1