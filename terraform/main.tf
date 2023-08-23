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
  // required
  username = var.SNOWFLAKE_USERNAME
  account  = var.SNOWFLAKE_ACCOUNT
  password = var.SNOWFLAKE_PASSWORD
  region   = var.SNOWFLAKE_REGION
}

module "snowflake_resources" {
  name    = "FIVETRAN_DATABASE"
  comment = "Fivetran database for loading in data."
  source  = "../modules/snowflake_resources"
}