# policy to allow ec2 instances to start their own tasks (i.e.: datadog)
resource "aws_iam_role_policy" "jenkins-ecs" {
    name = "jenkins-ecs"
    role = "${module.jenkins_master.ecs_instance_role_id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1452779658000",
            "Effect": "Allow",
            "Action": [
                "ecs:DescribeClusters",
                "ecs:RunTask",
                "ecs:StopTask",
                "ecs:RegisterTaskDefinition",
                "ecs:ListClusters"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

# policy to allow ec2 instances to start their own tasks (i.e.: datadog)
resource "aws_iam_role_policy" "jenkins-slave-ecr" {
    name = "ecrPermissions"
    role = "${module.jenkins_slave.ecs_instance_role_id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:BatchGetImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:PutImage"
        ],
        "Resource": "*"
    }]
}
EOF
}