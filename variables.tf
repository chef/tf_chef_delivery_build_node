variable "aws_ami_id" {}
variable "aws_flavor" {}
variable "aws_subnet_id" {}
variable "aws_security_groups_ids" {}
variable "aws_key_name" {}
variable "aws_ami_user" {}
variable "aws_private_key_file" {}
variable "instance_count" {}
variable "chef_server_url" {}
variable "delivery_enterprise" {}
variable "chef_organization" {}
variable "chef_environment" {
    default = "_default"
}
variable "instance_name_pattern" {
    default = "chef-delivery-build-node-%02d"
}
variable "run_list" {
    default = "recipe[delivery_build]"
}
