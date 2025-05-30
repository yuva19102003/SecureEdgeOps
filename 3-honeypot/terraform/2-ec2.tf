

resource "aws_instance" "this" {
    ami = "ami-080e1f13689e07408"
    instance_type = "t2.micro"
    key_name = "demo"
    subnet_id = aws_subnet.public.id 
    user_data = file("userdata.sh")    
    tags = {
      Name = "Honeypot-ec2"
    }
}
