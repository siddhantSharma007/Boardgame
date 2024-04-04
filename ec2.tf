resource "aws_instance" "example" {
   ami           = "ami-007020fd9c84e18c7"  
  instance_type = "t2.micro"              
  key_name      = "cicd"            

  tags = {
    Name = "ExampleInstance"
  }
}
