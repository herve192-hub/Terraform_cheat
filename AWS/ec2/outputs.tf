output "instance_id" {
  description = "Unique AWS identifier of the example EC2 instance."
  value       = aws_instance.example.id
}

output "public_ip" {
  description = "Public IPv4 address assigned to the example EC2 instance."
  value       = aws_instance.example.public_ip
}

output "website_url" {
  description = "HTTP URL for the example web page, built from the instance's public DNS name."
  value       = "http://${aws_instance.example.public_dns}"
}
