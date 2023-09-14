resource "snowflake_database" "tf_hex_database" {
  name    = "HEX"
  comment = "Hex database for loading in data."
  data_retention_time_in_days = 1
}

resource "snowflake_schema" "tf_hex_schema" {
  database = snowflake_database.tf_hex_database.name
  name     = "ML_PREDICTIONS"
  comment  = "A schema for model prediction tables coming from hex."
}

resource "snowflake_warehouse" "tf_hex_warehouse" {
  name           = "HEX_WAREHOUSE"
  comment        = "Hex warehouse for transforming data. Starting with xsmall but will change based on demand."
  warehouse_size = "XSMALL"
  warehouse_type = "STANDARD"
  auto_suspend = 60
  auto_resume = true
  initially_suspended = true
}

resource "snowflake_role" "tf_hex_role" {
  name    = "HEX_ROLE"
  comment = "hex role for loading data"
}

resource "snowflake_user" "tf_hex_user" {
  name         = "HEX_USER"
  login_name   = "HEX_USER"
  comment      = "Hex service account"
  password     = var.HEX_PASSWORD
  default_role = snowflake_role.tf_hex_role.name
  default_warehouse = snowflake_warehouse.tf_hex_warehouse.name
}

resource "snowflake_warehouse_grant" "tf_hex_warehouse_grant" {
  warehouse_name = snowflake_warehouse.tf_hex_warehouse.name
  privilege      = "USAGE"

  roles = [
        snowflake_role.tf_hex_role.name
      ]
}

resource "snowflake_role_grants" "tf_hex_grants" {
  role_name = snowflake_role.tf_hex_role.name
  
  // Roles that will inhert this role.
  roles = [
    "SYSADMIN"
  ]
  // What users should we grant this role to.
  users = [
    snowflake_user.tf_hex_user.name
  ]
}
