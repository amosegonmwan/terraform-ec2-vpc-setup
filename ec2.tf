resource "aws_instance" "project_ec2" {
  ami = var.ami_id
  instance_type = var.ec2_instance_type
  key_name = var.keypair_name
  subnet_id = aws_subnet.project_subnet.id

  tags = {
    Name = "project_ec2"
  }  
}
