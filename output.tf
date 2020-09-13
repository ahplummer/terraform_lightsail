output "static_ip_addr" {
  value = aws_lightsail_static_ip.staticIP.ip_address
}