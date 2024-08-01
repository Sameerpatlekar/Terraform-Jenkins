provider "aws" {
    region = "ap-south-1"  
}

resource "aws_instance" "foo" {
  ami           = "ami-0ad21ae1d0696ad58" # us-west-2
  instance_type = "t2.micro"
  key_name = "my-mumbai-key"
  tags = {
      Name = "TF-Instance"
  }
}

output "public_ip" {
   value =  aws_instance.foo.public_ip
}
