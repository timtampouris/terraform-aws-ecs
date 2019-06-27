provider "aws" {
  profile = "default"
  region  = "${var.aws_region}"
  version = "~> 2.16"
}
