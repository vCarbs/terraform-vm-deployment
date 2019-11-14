##################################################################################
# PROVIDERS
##################################################################################

provider "nutanix" {
  username     = var.username
  password     = var.password
  endpoint     = var.endpoint
  insecure     = var.insecure
  port         = var.port
  wait_timeout = var.wait_timeout
}

##################################################################################
# DATA
##################################################################################

data "nutanix_cluster" "cluster" {
  cluster_id = var.cluster_id[terraform.workspace]
}

#data "nutanix_image" "ubuntu" {
#    name = "Template_Ubuntu_18.04"
#    image_id = "b364e86c-30d1-420b-9c0b-ee1898c23d24"  
#}

#data "nutanix_subnet" "subnet" {
#    subnet_id = "c08a84bb-192c-4ec1-a1f1-2de6be72fcd1"
#    subnet_name = "NTNX - 10.1.101.0"
#}

data "template_file" "cloud" {
  count    = var.vmcount[terraform.workspace]
  template = "${file("cloudinit.tpl")}"
  vars = {
    name = "${var.vmname[terraform.workspace]}${count.index}"
  }
}


##################################################################################
# RESOURCES
##################################################################################

resource "nutanix_category_key" "environment" {
  name = "env"
}

resource "nutanix_category_value" "environment" {
  name = nutanix_category_key.environment.id
  value = var.categories[terraform.workspace]
}


resource "nutanix_virtual_machine" "vm" {
  depends_on = [nutanix_category_value.environment]
  count                = var.vmcount[terraform.workspace]
  name                 = "${var.vmname[terraform.workspace]}${count.index}"
  cluster_uuid         = data.nutanix_cluster.cluster.cluster_id
  num_vcpus_per_socket = 1
  num_sockets          = 1
  memory_size_mib      = var.memory[terraform.workspace]
  categories {
    name = "env"
    value = var.categories[terraform.workspace]
  }
  nic_list {
    subnet_uuid = "c08a84bb-192c-4ec1-a1f1-2de6be72fcd1"
  }
  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = "b364e86c-30d1-420b-9c0b-ee1898c23d24"
    }
  }
  disk_list {
    device_properties {
      disk_address = {
        device_index = 1
        adapter_type = "SCSI"
      }
      device_type = "DISK"
    }
    disk_size_mib = 20480
  }
  guest_customization_cloud_init_user_data = "${base64encode("${element(data.template_file.cloud.*.rendered, count.index)}")}"
}

##################################################################################
# OUTPUT
##################################################################################

output "ip_address" {
  value = "${lookup(nutanix_virtual_machine.vm[0].nic_list.0.ip_endpoint_list[0], "ip")}"
}

output "disk_id" {
  value = "${lookup(nutanix_virtual_machine.vm[0].disk_list.0, "uuid")}"
}