provider "aws" {
	region = "${var.region}"
	profile = "${var.profile}"
	max_retries = 5
}

module "vpc" {
	source = "git@github.com:MYOB-Technology/platform-terraform.git//modules/vpc"
	aws_region = "${var.region}"
	stack_name = "${var.cluster_name}"
	cidr_block = "${var.vpc_cidr}"
}

module "app" {
	source = "git@github.com:MYOB-Technology/platform-terraform.git//modules/ecs"

	cluster_name = "${var.cluster_name}"
	region = "${var.region}"
	internet_gateway_id = "${module.vpc.internet_gateway_id}"
	ssh_key = "${var.ssh_key}"
	instance_type = "${var.instance_type}"

	vpc_id = "${module.vpc.vpc_id}"
	cidr_block = "${var.vpc_cidr}"
	availability_zones = "${var.availability_zones}"
	subnet_offset = 30
	allowed_ips = "${var.allowed_ips}"
	subnet_newbits = 10

	asg_min_size = 1
	asg_desired_size = 1
	asg_max_size = 1
}

output "url" {
	value = "${module.app.address}"
}