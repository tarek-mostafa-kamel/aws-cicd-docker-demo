output "public_ip" {
  description = "Elastic IP of the web server"
  value       = aws_eip.web.public_ip
}

output "site_url" {
  value = "http://${aws_eip.web.public_ip}"
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/cicd-key ubuntu@${aws_eip.web.public_ip}"
}
