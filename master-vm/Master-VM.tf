resource "openstack_compute_instance_v2" "ysi-master-vm" {
  name            = "ysi-master-vm"
  image_name      = "Ubuntu-22.04-LTS"
  flavor_name     = "css.2c4r.10g"
  key_pair        = "yuvi_key"
  security_groups = ["sshOslomet"]

  network {
    name = "acit"
  }

  provisioner "file" {
    source      = "/home/yuvi/.ssh/yuvi_key"
    destination = "/home/ubuntu/.ssh/id_ed25519"

    connection {
      host        = self.access_ip_v4
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/yuvi_key")
    }

  }

  # Authentication in /home/ubuntu/.config/openstack/clouds.yaml
  provisioner "file" {
    source      = "/home/yuvi/.config/openstack"
    destination = "/home/ubuntu/openstack/.config"

    connection {
      host        = self.access_ip_v4
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/yuvi_key")
    }
  }

  provisioner "remote-exec" {
    connection {
      host        = self.access_ip_v4
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/yuvi_key")
    }

    inline = [
      # Installing Terraform
      "wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg",
      "echo \"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main\" | sudo tee /etc/apt/sources.list.d/hashicorp.list",
      "sudo apt update && sudo apt install terraform",
      "terraform --version",

      # Installing Openstack command line interaction
      "sudo NEEDRESTART_MODE=a apt install python3-pip -y",
      "pip --version",
      "pip install openstackclient",
      "echo \"export OS_CLOUD=openstack\" >> /home/ubuntu/.bashrc",
      "openstack --version",

      # Installing Ansible
      "sudo apt update",
      "sudo NEEDRESTART_MODE=a apt install software-properties-common -y",
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo NEEDRESTART_MODE=a apt install ansible -y",
      "sudo chmod 0400 /home/ubuntu/.ssh/id_ed25519",
      "ansible --version",
    ]
  }
}

output "master_ip" {
  value = openstack_compute_instance_v2.ysi-master-vm.access_ip_v4
}

