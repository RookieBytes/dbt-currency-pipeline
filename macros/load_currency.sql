{% macro load_currency_data() %}

    {% set insert_query %}
    INSERT INTO dbt_dboernse.stg_currency_rates (
        currency_date, base_currency, rate_eur, rate_usd, rate_gbp, 
        rate_chf, rate_jpy, rate_aud, rate_cad, rate_pln, loaded_at
    )
    SELECT 
        CAST(JSON_VALUE(raw_json, '$.date') AS DATE),
        CAST(JSON_VALUE(raw_json, '$.base') AS NVARCHAR(10)),
        COALESCE(CAST(JSON_VALUE(raw_json, '$.rates.EUR') AS FLOAT), 1.0),
        CAST(JSON_VALUE(raw_json, '$.rates.USD') AS FLOAT),
        CAST(JSON_VALUE(raw_json, '$.rates.GBP') AS FLOAT),
        CAST(JSON_VALUE(raw_json, '$.rates.CHF') AS FLOAT),
        CAST(JSON_VALUE(raw_json, '$.rates.JPY') AS FLOAT),
        CAST(JSON_VALUE(raw_json, '$.rates.AUD') AS FLOAT),
        CAST(JSON_VALUE(raw_json, '$.rates.CAD') AS FLOAT),
        CAST(JSON_VALUE(raw_json, '$.rates.PLN') AS FLOAT),
        ingestion_time
    FROM raw_currency_data
    WHERE ingestion_time > (SELECT ISNULL(MAX(loaded_at), '1900-01-01') FROM dbt_dboernse.stg_currency_rates);
    {% endset %}

    {% do run_query(insert_query) %}
    {{ log("Log: Die Währungsdaten wurden erfolgreich in die Tabelle geschoben!", info=True) }}

{% endmacro %}