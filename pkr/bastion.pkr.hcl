variable "service_account_email" {
  type = string
  default = "master-ue1@dojolaunch-302702.iam.gserviceaccount.com" 
}

variable "zone" {
  type = string
  default = "us-east1-b"
}

variable "source_Image_family" {
  type = string
  default = "debian-10"
}

variable "source_image" {
  type = string
  default = "debian-10-buster-v20210217"
}

variable "machine_type" {
  type = string
  default = "e2-medium"
}

variable "disk_size" {
  type = number
  default = 30
}

variable "instance_name" {
  type = string
  default = "bastion-ue1"
}

variable "use_os_login" {
  type = bool
  default = true
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "googlecompute" "bastion" {

  project_id              = "dojolaunch-302702"
  ssh_username            = "packer"

  source_image            = var.source_image
  source_image_family     = var.source_Image_family

  zone                    = var.zone
  machine_type            = var.machine_type
  disk_size               = var.disk_size
  instance_name           = var.instance_name

  service_account_email   = var.service_account_email 
  use_os_login            = var.use_os_login

}

build {
    
  sources = ["sources.googlecompute.bastion"]
  provisioner "shell" { script = "bastion.sh" }

}