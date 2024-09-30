# packer {
#   required_plugins {
#     amazon = {
#       source  = "github.com/hashicorp/amazon"
#       version = "~> 1"
#     }
#   }
# }

variable "imageName"{
  type = string
  default = "packer-image-2024"
}

source "amazon-ebs" "basic-example" {
  access_key = "AKIAQWC7OMED2NYWBQF5"
  secret_key = "zxLJ43eNHSAGptuvuPZbeHWbJJzkDlPC7kVN0l+4"
  region     = "us-east-1"
  ami_name = "${var.imageName}-05"
  ami_description = "Image generated from packer"
  instance_type = "t2.micro"
  source_ami = "ami-0e86e20dae9224db8"
  ssh_username = "ubuntu"
}
build {
  sources = [
    "source.amazon-ebs.basic-example"
  ]
  # sleep 30 for booting up the os properly
  provisioner "shell" {
      script       = "setup.sh"
  }
  provisioner "file" {
    destination = "/tmp/"
    source      = "index.html"
  }
    provisioner "shell" {
      inline       = ["sudo cp /tmp/index.html /var/www/html/"]
  }
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
    custom_data = {
      my_custom_data = "example"
    }
}

} 
