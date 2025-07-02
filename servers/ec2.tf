data "aws_ami" "ubuntu-east-1" {
  provider = aws.east-1
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "ubuntu-west-2" {
  provider = aws.west-2
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "web-east-1" {
  provider      = aws.east-1
  ami           = data.aws_ami.ubuntu-east-1.id
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-test-east-1"
  }
}

resource "aws_instance" "web-west-2" {
  provider      = aws.west-2
  ami           = data.aws_ami.ubuntu-west-2.id
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-test-west-2"
  }
}
