import snowflake.connector
from cryptography.hazmat.primitives import serialization
 
def get_connection():
 
    with open("rsa_key.p8", "rb") as key_file:
        p_key = serialization.load_pem_private_key(
            key_file.read(),
            password=None
        )
 
    private_key = p_key.private_bytes(
        encoding=serialization.Encoding.DER,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    )
 
    conn = snowflake.connector.connect(
        user="SVC_SUPPLYCHAIN",               # or SVC_SUPPLYCHAIN
        account="xogtmpm-fd65747",
        private_key=private_key,
        warehouse="COMPUTE_WH",
        database="SUPPLYCHAIN",
        schema="STG",
        client_session_keep_alive=True
    )
 
    print("Snowflake Connected")
 
    return conn