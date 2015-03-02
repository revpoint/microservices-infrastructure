variable auth_url	{ default = {} }
variable tenant_id	{ default = {} }
variable tenant_name	{ default = {} }
variable regions	{ default = {} }
variable flavor_name	{ default = {} }
variable net_id		{ default = {} }
variable host_prefix	{ default = {} }

variable public_key	{}
variable keypair_name	{}
variable image_name	{}

variable "instance_names" {
	default = {
		"0" = "host-01"
		"1" = "host-02"
		"2" = "host-03"
		"3" = "host-04"
		"4" = "host-05"
	}
}

variable "dc" { default = "dc2" }

provider "openstack" {
  auth_url	= "${ lookup(var.auth_url, var.dc) }"
  tenant_id	= "${ lookup(var.tenant_id, var.dc) }"
  tenant_name	= "${ lookup(var.tenant_name, var.dc) }"
}

resource "openstack_compute_keypair_v2" "keypair" {
  region	= "${ lookup(var.regions, var.dc) }"
  name		= "${ var.keypair_name }"
  public_key	= "${ file(var.public_key) }"
}

resource "openstack_compute_secgroup_v2" "microservices" {
  region		= "${ lookup(var.regions, var.dc) }"
  name			= "microservices-secgroup"
  description		= "Microservces Security Group"
  rule {
	from_port	= "1"
	to_port		= "65535"
	ip_protocol	= "tcp"
	cidr		= "192.168.126.0/24"
  }
  rule {
	from_port	= "1"
	to_port		= "65535"
	ip_protocol	= "tcp"
	cidr		= "173.37.0.0/16"
  }
  rule {
	from_port	= "1"
	to_port		= "65535"
	ip_protocol	= "tcp"
	cidr		= "173.39.0.0/16"
  }
  rule {
	from_port	= "1"
	to_port		= "65535"
	ip_protocol	= "tcp"
	cidr		= "128.107.0.0/16"
  }
  rule {
	from_port	= "-1"
	to_port		= "-1"
	ip_protocol	= "icmp"
	cidr		= "0.0.0.0/0"
  }
  rule {
	ip_protocol	= "tcp"
	from_port	= "22"
	to_port		= "22"
	cidr		= "0.0.0.0/0"
  }
}
	
resource "openstack_compute_instance_v2" "node" {
  region		= "${ lookup(var.regions, var.dc) }"
  name			= "${ lookup(var.instance_names, count.index) }"
  key_pair		= "${ openstack_compute_keypair_v2.keypair.name }"
  image_name		= "${ var.image_name }"
  flavor_name		= "${ lookup(var.flavor_name, var.dc) }"
  security_groups	= [ "${ openstack_compute_secgroup_v2.microservices.name }" ]
  network		= { uuid = "${ lookup(var.net_id, var.dc) }" }
  count = 5
}

