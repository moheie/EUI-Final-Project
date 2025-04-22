output "ssh_private_key_path" {
  value       = local_file.private_key.filename
}

output "jenkins_eip" {
  value = aws_eip.jenkins_eip.public_ip
}


output "webserver_eip" {
  value = aws_eip.webserver_eip.public_ip
}


