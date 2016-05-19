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

module "jenkins_master" {
	source = "git@github.com:MYOB-Technology/platform-terraform.git//modules/ecs"

	cluster_name = "master"
	region = "${var.region}"
	internet_gateway_id = "${module.vpc.internet_gateway_id}"
	ssh_key = "${var.ssh_key}"
	instance_type = "${var.instance_type_for_master}"

	vpc_id = "${module.vpc.vpc_id}"
	cidr_block = "${var.vpc_cidr}"
	availability_zones = "${var.availability_zones}"
	subnet_offset = 10
	allowed_ips = "${var.allowed_ips}"
	subnet_newbits = 10

	asg_min_size = 1
	asg_desired_size = 1
	asg_max_size = 1

	# create this directory and set the uid and gid to the jenkins user for the container to be able to write to it
	user_data_extra_script = "mkdir -p /var/jenkins_home/logs && chown -R 1000:1000 /var/jenkins_home/"
}

module "jenkins_slave" {
	source = "git@github.com:MYOB-Technology/platform-terraform.git//modules/ecs"

	cluster_name = "slave"
	region = "${var.region}"
	internet_gateway_id = "${module.vpc.internet_gateway_id}"
	ssh_key = "${var.ssh_key}"
	instance_type = "${var.instance_type_for_slave}"

	vpc_id = "${module.vpc.vpc_id}"
	cidr_block = "${var.vpc_cidr}"
	availability_zones = "${var.availability_zones}"
	subnet_offset = 20
	allowed_ips = "${var.allowed_ips}"
	subnet_newbits = 10


	asg_min_size = 0
	asg_desired_size = 1
	asg_max_size = 5
}

output "jenkins_address" {
	value = "${module.jenkins_master.address}"
}