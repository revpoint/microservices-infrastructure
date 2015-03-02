#!/usr/bin/env python

import json

fp = file("terraform.tfstate", "r")
inv = json.load(fp)
fp.close()

for module in inv["modules"]:
	for reskey in module["resources"].keys():
		res = module["resources"][reskey]

		if (res["type"] == "openstack_compute_instance_v2"):
			a = res["primary"]["attributes"]

			print(a["name"] + " ansible_ssh_host=" + a["access_ip_v4"])
