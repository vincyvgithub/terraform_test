resource "aws_instance" "myinstance1" {
        ami = "ami-08e637cea2f053dfa"         # RHEL 9 Ami on us-east-1 region
        instance_type = "t2.micro"
        key_name = "test"  ###  if ssh access is needed Generate the key manually from web console
        subnet_id = aws_subnet.mysubnet1.id
        vpc_security_group_ids = [aws_security_group.mysg1.id]
        user_data = <<-EOF
        sudo yum install httpd -y
        echo "<marquee><h1>Hello From VINCY</h1></marquee>" > /var/www/html/index.html
        sudo systemctl restart httpd
        sudo systemctl enable httpd
        EOF
        tags = {
                Name = "Webserver1"
        }
}

