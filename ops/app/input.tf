variable "region" {
  description = "AWS Region (us-east-1, as-southeast-1, ...)"
  type = "string"
}

variable "profile" {
  description = "AWS Profile as named in your ~/.aws/credentials"
  type = "string"
}

variable "cluster_name" {
  description = "The name you would like your cluster to have"
  type = "string"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "availability_zones" {
  description = "Availability Zones for the specified region and account in a CSV format (eg.:'a,c')"
}

variable "ssh_key" {
  descripton = "The ssh key name to be used in any EC2 instances, make sure the key exists. Leave blank for no ssh access."
  default = ""
}

variable "allowed_ips" {
  default = "210.10.223.248/30,203.34.100.2/32"
}