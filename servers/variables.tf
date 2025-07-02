variable "image_id" {
  default = "ami-020cba7c55df1f615"
  type = string
}

variable "instance_type" {
  default = "t2.micro"
}

variable "tags" {
  default = "terraform-test"
  type = string
}