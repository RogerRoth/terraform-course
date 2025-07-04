data "aws_ami" "ubuntu-east-1" {
  provider    = aws.east-1
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "web-east-1" {
  count         = var.instance_count
  provider      = aws.east-1
  ami           = data.aws_ami.ubuntu-east-1.id
  instance_type = var.instance_type
  tags = {
    Name    = "${var.project_name}-east-1-${count.index + 1}"
    Project = var.project_name
  }
}
