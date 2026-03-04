{{ config(materialized='view') }}

/* Wir nutzen 'view', weil Azure SQL beim Erstellen von Views 
   keinen komplizierten 'RENAME'-Befehl braucht. 
*/

WITH source_data AS (
    SELECT 
        filename_source,
        ingestion_time,
        -- JSON-Parsing für Azure SQL
        JSON_VALUE(raw_json, '$.date') as exchange_date,
        JSON_VALUE(raw_json, '$.base') as base_currency,
        CAST(JSON_VALUE(raw_json, '$.rates.EUR') AS FLOAT) as rate_eur
    FROM raw_currency_data
)

SELECT 
    CAST(exchange_date AS DATE) as currency_date,
    base_currency,
    rate_eur,
    ingestion_time as loaded_at
FROM source_data