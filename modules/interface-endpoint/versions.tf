terraform {
  required_version = ">= 1.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.12"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.14"
    }
  }
}
