resource "snowflake_database" "tf_fivetran_database" {
  name    = "FIVETRAN"
  comment = "Fivetran database for loading in data."
  data_retention_time_in_days = 10
}

resource "snowflake_warehouse" "tf_fivetran_warehouse" {
  name           = "FIVETRAN_WAREHOUSE"
  comment        = "Fivetran warehouse for loading data. Starting with xsmall but will change based on demand."
  warehouse_size = "XSMALL"
  warehouse_type = "STANDARD"
  auto_suspend = 60
  auto_resume = true
  initially_suspended = true
}

resource "snowflake_role" "tf_fivetran_role" {
  name    = "FIVETRAN_ROLE"
  comment = "Fivetran role for loading data"
}

resource "snowflake_user" "tf_fivetran_user" {
  name         = "FIVETRAN_USER"
  login_name   = "FIVETRAN_USER"
  comment      = "Fivetran service account"
  password     = var.FIVETRAN_PASSWORD
  default_role = snowflake_role.tf_fivetran_role.name
  default_warehouse = snowflake_warehouse.tf_fivetran_warehouse.name
}

resource "snowflake_warehouse_grant" "tf_fivetran_warehouse_grant" {
  warehouse_name = snowflake_warehouse.tf_fivetran_warehouse.name
  privilege      = "USAGE"

  roles = [
        snowflake_role.tf_fivetran_role.name
      ]
}

resource "snowflake_database_grant" "tf_fivetran_database_grant" {
  database_name = snowflake_database.tf_fivetran_database.name
  privilege = "ALL PRIVILEGES"
  roles     = [
    snowflake_role.tf_fivetran_role.name,
    "DBT_ROLE"
  ]
}

resource "snowflake_role_grants" "tf_fivetran_grants" {
  role_name = snowflake_role.tf_fivetran_role.name
  
  // Roles that will inhert this role.
  roles = [
    "DBT_ROLE"
  ]
  // What users should we grant this role to.
  users = [
    snowflake_user.tf_fivetran_user.name
  ]
}