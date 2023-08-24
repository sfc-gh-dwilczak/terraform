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
  source  = "./modules/fivetran_resources"
  FIVETRAN_PASSWORD = var.FIVETRAN_PASSWORD
}

module "dbt_resources" {
  source  = "./modules/dbt_resources"
  DBT_PASSWORD = var.DBT_PASSWORD
}