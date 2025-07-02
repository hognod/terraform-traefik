resource "terraform_data" "script" {
  connection {
    host = aws_instance.public.public_ip
    user = var.os_user
    private_key = tls_private_key.key_pair.private_key_pem

    timeout = "2m"
  }

  provisioner "file" {
    source = "${path.module}/traefik"
    destination = "/home/ubuntu/traefik"
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/docker_install.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
      "mkdir ~/traefik/acme",
      "touch ~/traefik/acme/acme.json",
      "chmod 600 ~/traefik/acme/acme.json",

      "docker network create traefik",
      "echo \"TRAEFIK_HOST=${var.domain_name}\" >> ~/traefik/.env",
      "sed -i 's/$${TRAEFIK_EMAIL}/${var.email}/g' ~/traefik/traefik/traefik.yml"
    ]
  }
}