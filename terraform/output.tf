output "Jnkins_public_address" {
  value       = "${aws_instance.Scalac.public_ip}:8080"
  description = "The public address of Jenkins EC2 instance"
}
