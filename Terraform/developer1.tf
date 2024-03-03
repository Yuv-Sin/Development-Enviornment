resource "openstack_compute_instance_v2" "ysi_developer_1" {
  name            = "ysi_developer_1"
  image_name      = "Ubuntu-22.04-LTS"
  flavor_name     = "css.2c4r.10g"
  key_pair        = "yuvi_key" 
  security_groups = ["sshOslomet"]

  network {
    name = "acit"
  }
}

output "ysi_developer_1" {
  value = openstack_compute_instance_v2.ysi_developer_1.access_ip_v4
}