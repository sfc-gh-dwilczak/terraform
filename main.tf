terraform {
  // Snowflake setup
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.69.0"
    }
  }
  cloud {
    organization = "snowflake_demo_account"

    workspaces {
      name = "aws_demo_account"
    }
  }
}

provider "snowflake" {
  username = var.SNOWFLAKE_USERNAME
  account  = var.SNOWFLAKE_ACCOUNT
  password = var.SNOWFLAKE_PASSWORD
  region   = var.SNOWFLAKE_REGION
}

module "fivetran_resources" {
  source  = "./modules/fivetran"
  FIVETRAN_PASSWORD = var.FIVETRAN_PASSWORD
}

module "dbt_resources" {
  source  = "./modules/dbt"
  DBT_PASSWORD = var.DBT_PASSWORD
}

module "hex_resources" {
  source  = "./modules/hex"
  HEX_PASSWORD = var.HEX_PASSWORD
}

module "thoughtspot_resources" {
  source  = "./modules/thoughtspot"
  THOUGHTSPOT_PASSWORD = var.THOUGHTSPOT_PASSWORD
}