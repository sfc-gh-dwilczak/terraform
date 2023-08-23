resource "snowflake_database" "tf_dbt_database" {
  name    = "DBT_DATABASE"
  comment = "DBT database for loading in data."
  data_retention_time_in_days = 1
}

resource "snowflake_warehouse" "tf_dbt_warehouse" {
  name           = "DBT_WAREHOUSE"
  comment        = "DBT warehouse for transforming data. Starting with xsmall but will change based on demand."
  warehouse_size = "xsmall"
  warehouse_type = "standard"
  auto_suspend = 60
  auto_resume = true
  initially_suspended = true
}

resource "snowflake_role" "tf_dbt_role" {
  name    = "DBT_ROLE"
  comment = "DBT role for loading data"
}

resource "snowflake_user" "tf_dbt_user" {
  name         = "DBT_USER"
  login_name   = "DBT_USER"
  comment      = "DBT service account"
  password     = "password123"
  default_role = snowflake_role.tf_dbt_role.name
  default_warehouse = snowflake_warehouse.tf_dbt_warehouse.name
}

resource "snowflake_warehouse_grant" "tf_dbt_warehouse_grant" {
  warehouse_name = snowflake_warehouse.tf_dbt_warehouse.name
  privilege      = "USAGE"

  roles = [
        snowflake_role.tf_dbt_role.name
      ]
}

resource "snowflake_database_grant" "tf_dbt_database_grant" {
  database_name = snowflake_database.tf_dbt_database.name
  privilege = "ALL PRIVILEGES"
  roles     = [snowflake_role.tf_dbt_role.name]
}

resource "snowflake_role_grants" "tf_dbt_grants" {
  role_name = snowflake_role.tf_dbt_role.name
  
  // Roles that will inhert this role.
  roles = [
    "SYSADMIN"
  ]
  // What users should we grant this role to.
  users = [
    snowflake_user.tf_dbt_user.name
  ]
}
