resource "aws_security_group_rule" "jenkins_jnlp" {
  type = "ingress"
  from_port = 50000
  to_port = 50000
  protocol = "tcp"

  security_group_id = "${module.jenkins_master.ecs_security_group_id}"
  source_security_group_id = "${module.jenkins_slave.ecs_security_group_id}"
}

resource "aws_security_group_rule" "jenkins_slave_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"

  security_group_id = "${module.jenkins_master.ecs_security_group_id}"
  source_security_group_id = "${module.jenkins_slave.ecs_security_group_id}"
}

resource "aws_security_group_rule" "master_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"

  security_group_id = "${module.jenkins_master.ecs_security_group_id}"
  cidr_blocks = ["${split(",",var.allowed_ips)}"]
}

resource "aws_security_group_rule" "slave_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"

  security_group_id = "${module.jenkins_slave.ecs_security_group_id}"
  cidr_blocks = ["${split(",", var.allowed_ips)}"]
}

