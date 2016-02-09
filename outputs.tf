output "public-ips" {
  value = "${join(",", aws_instance.chef-delivery-build-node.*.public_ip)}"
}
