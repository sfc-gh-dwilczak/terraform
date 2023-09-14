resource "snowflake_database" "tf_thoughtspot_database" {
  name    = "THOUGHTSPOT"
  comment = "Thoughtspot database for loading in data."
  data_retention_time_in_days = 1
}

resource "snowflake_warehouse" "tf_thoughtspot_warehouse" {
  name           = "THOUGHTSPOT_WAREHOUSE"
  comment        = "Thoughtspot warehouse for transforming data. Starting with xsmall but will change based on demand."
  warehouse_size = "XSMALL"
  warehouse_type = "STANDARD"
  auto_suspend = 60
  auto_resume = true
  initially_suspended = true
}

resource "snowflake_role" "tf_thoughtspot_role" {
  name    = "THOUGHTSPOT_ROLE"
  comment = "Thoughtspot role for loading data"
}

resource "snowflake_user" "tf_thoughtspot_user" {
  name         = "THOUGHTSPOT_USER"
  login_name   = "THOUGHTSPOT_USER"
  comment      = "THOUGHT SPOT service account"
  password     = var.THOUGHTSPOT_PASSWORD
  default_role = snowflake_role.tf_thoughtspot_role.name
  default_warehouse = snowflake_warehouse.tf_thoughtspot_warehouse.name
}

resource "snowflake_warehouse_grant" "tf_thoughtspot_warehouse_grant" {
  warehouse_name = snowflake_warehouse.tf_thoughtspot_warehouse.name
  privilege      = "USAGE"

  roles = [
        snowflake_role.tf_thoughtspot_role.name
      ]
}

resource "snowflake_role_grants" "tf_thoughtspot_grants" {
  role_name = snowflake_role.tf_thoughtspot_role.name
  
  // Roles that will inhert this role.
  roles = [
    "SYSADMIN"
  ]
  // What users should we grant this role to.
  users = [
    snowflake_user.tf_thoughtspot_user.name
  ]
}
