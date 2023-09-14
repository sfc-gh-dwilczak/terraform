resource "snowflake_database" "tf_dbt_database_prod" {
  name    = "DBT_PROD"
  comment = "DBT database curating data but this is the production database."
  data_retention_time_in_days = 1
}

resource "snowflake_warehouse_grant" "tf_dbt_warehouse_grant_prod" {
  warehouse_name = "DBT_WAREHOUSE"
  privilege      = "USAGE"
  roles = [
        "DBT_ROLE"
      ]
}

resource "snowflake_database_grant" "tf_dbt_database_grant_prod" {
  database_name = snowflake_database.tf_dbt_database_prod.name
  privilege = "ALL PRIVILEGES"
  roles     = ["DBT_ROLE"]
}