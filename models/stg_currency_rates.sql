{{ config(
    materialized='view',
    full_refresh=true
) }}

/* Wir erzwingen 'full_refresh', damit dbt nicht versucht, 
   alte Versionen umzubenennen (was in Azure SQL scheitert).
*/

SELECT 
    CAST(JSON_VALUE(raw_json, '$.date') AS DATE) as currency_date,
    CAST(JSON_VALUE(raw_json, '$.base') AS NVARCHAR(10)) as base_currency,
    CAST(JSON_VALUE(raw_json, '$.rates.EUR') AS FLOAT) as rate_eur,
    ingestion_time as loaded_at
FROM raw_currency_data