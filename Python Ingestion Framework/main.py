from read_csv import read_csv
from snowflake_connect import get_connection
from load_to_snowflake import load_dataframe
 
conn = get_connection()

lis = ['ERP_Customers','ERP_Invoices','ERP_Products','ERP_Sales_Order_Items','ERP_Sales_Orders']

for i in lis:

    SOURCE_OBJECT = i
    
    df = read_csv(SOURCE_OBJECT)
    
    df.columns = [col.upper() for col in df.columns]
    
    load_dataframe(
        conn,
        df,
        SOURCE_OBJECT
    )
 
# conn.close()