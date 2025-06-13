resource "terraform_data" "script" {
  connection {
    host = aws_instance.public.public_ip
    user = var.os_user
    private_key = tls_private_key.key_pair.private_key_pem

    timeout = "2m"
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/docker_install.sh"
  }
}