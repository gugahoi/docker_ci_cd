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

variable "jenkins_image_url" {
  description = "The URL for the Jenkins image"
  type = "string"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "instance_type_for_master" {
  default = "t2.micro"
}

variable "instance_type_for_slave" {
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

variable "memory_allocation" {
  description = "Memory characteristics for each instance type so we can allocate parts to task definitions"
  # https://aws.amazon.com/ec2/instance-types/
  type = "map"
  default = {
    t2.nano   = "500"
    t2.micro  = "1000"
    t2.small  = "2000"
    t2.medium = "4000"
    t2.large  = "8000"
    m3.medium   = "3750"
    m3.large    = "7500"
    m3.xlarge   = "15000"
    m3.2xlarge  = "30000"
  }
}
