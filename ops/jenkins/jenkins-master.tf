resource "aws_ecs_task_definition" "jenkins_master" {
  family = "${var.cluster_name}-jenkins-master"
  container_definitions = <<EOF
[
  {
    "memory": ${lookup(var.memory_allocation, var.instance_type_for_master) * 0.9},
    "portMappings": [
      {
        "hostPort": 50000,
        "containerPort": 50000,
        "protocol": "tcp"
      },
      {
        "hostPort": 80,
        "containerPort": 8080,
        "protocol": "tcp"
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "jenkins-home", 
        "containerPath": "/var/jenkins_home"
      }
    ],
    "environment": [
      {
        "name": "JENKINS_OPTS",
        "value": "--logfile=/var/jenkins_home/logs/jenkins.log"
      },
      {
        "name": "JAVA_OPTS",
        "value": "-Xmx${lookup(var.memory_allocation, var.instance_type_for_master) * 0.9}M"
      }
    ],
    "essential": true,
    "name": "jenkins",
    "image": "${var.jenkins_image_url}"
  }
]
EOF

  volume {
    name = "jenkins-home"
    host_path = "/var/jenkins_home"
  }

}

resource "aws_ecs_service" "jenkins_master" {
  name = "${var.cluster_name}-jenkins-master"
  cluster = "${module.jenkins_master.cluster_id}"
  task_definition = "${aws_ecs_task_definition.jenkins_master.arn}"
  desired_count = 1
  iam_role = "${module.jenkins_master.ecs_service_role_arn}"
  deployment_minimum_healthy_percent = 0
  # depends_on = ["aws_iam_role_policy.foo"]

  load_balancer {
    elb_name = "${module.jenkins_master.elb_name}"
    container_name = "jenkins"
    container_port = 8080
  }
}
