# Setup chef-delivery-build-node
resource "aws_instance" "chef-delivery-build-node" {
  ami = "${var.aws_ami_id}"
  count = "${var.instance_count}"
  instance_type = "${var.aws_flavor}"
  subnet_id = "${var.aws_subnet_id}"
  vpc_security_group_ids = ["${var.aws_security_groups_ids}"]
  key_name = "${var.aws_key_name}"
  tags {
    Name = "${format(var.instance_name_pattern, count.index + 1)}"
  }
  root_block_device = {
    delete_on_termination = true
  }
  connection {
    user = "${var.aws_ami_user}"
    key_file = "${var.aws_private_key_file}"
  }

  # For now there is no way to delete the node from the chef-server
  # and also there is no way to customize your `destroy` actions
  # https://github.com/hashicorp/terraform/issues/649
  #
  # Workaround: Force-delete the node before hand
  # Note: If the name pattern is changed you must manually delete the
  #       node on chef server.
  provisioner "local-exec" {
    command = <<EOF
    knife client delete ${format(var.instance_name_pattern, count.index + 1)} -y
    knife node delete ${format(var.instance_name_pattern, count.index + 1)} -y
    echo "Workaround: Force-delete the node & client from the chef-server before hand"
EOF
  }

  # Copies certificates
  provisioner "file" {
    source = ".chef/trusted_certs"
    destination = "/tmp"
  }

  # Configure certificates
  provisioner "remote-exec" {
    inline = [
      "sudo service iptables stop",
      "sudo chkconfig iptables off",
      "sudo mkdir -p /etc/chef",
      "sudo mv /tmp/trusted_certs /etc/chef/."
    ]
  }

  provisioner "chef"  {
    attributes {
      "delivery_build" {
        "delivery-cli" {
          "options" = "--nogpgcheck"
        }
        # "trusted_certs" {
        #   "Delivery-Server-Cert" = "/etc/chef/trusted_certs/.crt"
        #   "Supermarket-Server" = "/etc/chef/trusted_certs/supermarket_server_fqdn.crt"
        # }
      }
    }
    # Perhaps we want to install chefdk on the build-nodes
    # if so, we can skip the chef-client install
    # skip_install = true
    run_list = ["delivery_build"]
    node_name = "${format(var.instance_name_pattern, count.index + 1)}"
    secret_key = "${path.cwd}/.chef/encrypted_data_bag_secret"
    server_url = "${var.chef_server_url}"
    validation_client_name = "${var.chef_organization}-validator"
    validation_key = "${file("${path.cwd}/.chef/${var.chef_organization}-validator.pem")}"
  }
}
