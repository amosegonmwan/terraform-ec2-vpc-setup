output "ec2_public_ip" {
  value = aws_instance.project_ec2.public_ip
}

output "vpc_id" {
  value = aws_vpc.project_vpc.id
}