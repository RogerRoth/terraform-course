resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform-state-lock"
  hash_key = "LockID"
  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}