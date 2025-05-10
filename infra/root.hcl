terragrunt_version_constraint = "v0.71.1"

locals {
  system = "example-system"
  region = "ap-northeast-1"
}

remote_state {
  backend = "s3"
  generate = {
    path           = "_backend.tf"
    if_exists      = "overwrite_terragrunt"
  }
  config = {
    bucket         = "${local.system}-terraform-states"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

generate "provider" {
  path      = "_provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_version = "~> 1.10.3"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.95"
    }
  }
}

provider "aws" {
  region = "${local.region}"
  default_tags {
    tags = {
      iac       = "true"
      system    = "${local.system}"
    }
  }
}
EOF
}

terraform {
  before_hook "fortmat" {
    commands = ["plan"]
    execute  = ["terraform", "fmt"]
  }
  before_hook "validate" {
    commands = ["apply"]
    execute  = ["terraform", "validate"]
  }
}