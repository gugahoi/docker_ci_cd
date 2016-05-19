variable "profile" {}

provider "aws" {
	region = "us-west-2"
	profile = "${var.profile}"
	max_retries = 5
}

resource "aws_ecr_repository" "app" {
  name = "sample-ci-cd"

  lifecycle {
  	prevent_destroy = true
  }
}

output "url" {
	value = "${aws_ecr_repository.app.repository_url}"
}