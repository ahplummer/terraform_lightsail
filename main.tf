resource "aws_lightsail_instance" "lightsail" {
  name              = var.VPS_NAME
  availability_zone = var.AVAIL_ZONE
  blueprint_id      = "amazon_linux_2018_03_0_2"
  bundle_id         = "nano_1_0"
  key_pair_name     = var.KEYS_NAME
  provisioner "local-exec" {
    command = "aws lightsail open-instance-public-ports --instance-name ${var.VPS_NAME} --region ${var.REGION} --port-info fromPort=8080,toPort=8080,protocol=tcp"
  }
  provisioner "local-exec" {
    command = "aws lightsail open-instance-public-ports --instance-name ${var.VPS_NAME} --region ${var.REGION} --port-info fromPort=5000,toPort=5000,protocol=tcp"
  }
}
resource "aws_lightsail_static_ip" "staticIP" {
  name = "${var.VPS_NAME}-ip"
}
resource "aws_lightsail_static_ip_attachment" "attachment" {
  static_ip_name = aws_lightsail_static_ip.staticIP.id
  instance_name  = aws_lightsail_instance.lightsail.id
}