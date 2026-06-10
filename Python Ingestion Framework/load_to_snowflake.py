from snowflake.connector.pandas_tools import write_pandas
 
 
TABLE_CONFIG = {
    "ERP_CUSTOMERS": {
        "pk": "CUSTOMER_ID",
        "watermark": "MODIFIED_DATE"
    },
    "ERP_PRODUCTS": {
        "pk": "PRODUCT_ID",
        "watermark": "MODIFIED_DATE"
    },
    "ERP_SALES_ORDERS": {
        "pk": "SALES_ORDER_ID",
        "watermark": "MODIFIED_DATE"
    },
    "ERP_SALES_ORDER_ITEMS": {
        "pk": "SALES_ORDER_ITEM_ID",
        "watermark": None
    },
    "ERP_INVOICES": {
        "pk": "INVOICE_ID",
        "watermark": None
    }
}
 
 
def load_dataframe(conn, df, table_name):
 
    table_name = table_name.upper()
    df.columns = [col.upper() for col in df.columns]
 
    temp_table = f"TMP_{table_name}"
 
    pk = TABLE_CONFIG[table_name]["pk"]
    watermark = TABLE_CONFIG[table_name]["watermark"]
 
    cursor = conn.cursor()
 
    try:
 
        cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
 
        # Load dataframe to temp table
        write_pandas(
            conn,
            df,
            table_name=temp_table,
            auto_create_table=True,
            overwrite=True
        )
 
        columns = [col.upper() for col in df.columns]
 
        update_cols = [
            col for col in columns
            if col != pk
        ]
 
        update_clause = ", ".join(
            [f"tgt.{col}=src.{col}" for col in update_cols]
        )
 
        insert_columns = ", ".join(columns)
 
        insert_values = ", ".join(
            [f"src.{col}" for col in columns]
        )
 
        if watermark:
 
            merge_sql = f"""
            MERGE INTO {table_name} tgt
            USING {temp_table} src
            ON tgt.{pk} = src.{pk}
 
            WHEN MATCHED
            AND src.{watermark} > tgt.{watermark}
            THEN UPDATE SET
            {update_clause}
 
            WHEN NOT MATCHED THEN
            INSERT ({insert_columns})
            VALUES ({insert_values})
            """
 
        else:
 
            merge_sql = f"""
            MERGE INTO {table_name} tgt
            USING {temp_table} src
            ON tgt.{pk} = src.{pk}
 
            WHEN NOT MATCHED THEN
            INSERT ({insert_columns})
            VALUES ({insert_values})
            """
 
        cursor.execute(merge_sql)

        result = cursor.fetchone()

 
        inserted = result[0] if len(result) > 0 else 0
        updated = result[1] if len(result) > 1 else 0
        
        print(f"Rows Inserted : {inserted}")
        print(f"Rows Updated  : {updated}")

 
        cursor.execute(
            f"DROP TABLE IF EXISTS {temp_table}"
        )
 
        conn.commit()
 
        print(f"Incremental Load Completed : {table_name}")
 
    except Exception:
 
        success, nchunks, nrows, _ = write_pandas(
            conn,
            df,
            table_name=table_name,
            auto_create_table=True,
            overwrite=True
        )
 
        print(f"Incremental Load Completed : {table_name}")
        print(f"Source Rows Processed : {len(df)}")