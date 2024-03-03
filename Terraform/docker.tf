resource "openstack_compute_instance_v2" "ysi_docker" {
  name            = "ysi_docker"
  image_name      = "Ubuntu-22.04-LTS"
  flavor_name     = "css.2c4r.10g"
  key_pair        = "yuvi_key" 
  security_groups = ["sshOslomet"]

  network {
    name = "acit"
  }
}

output "ysi_docker" {
  value = openstack_compute_instance_v2.ysi_docker.access_ip_v4
}