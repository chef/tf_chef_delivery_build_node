# `tf_chef_delivery_build_node`

A Terraform module to create Chef Delivery Build-Nodes.

Module Input Variables
----------------------

- `aws_ami_id` - AWS ami id.
- `aws_flavor` - The AWS instance type.
- `aws_subnet_id` - The AWS id of the subnet to use.
- `aws_security_groups_ids` - The AWS security group id for this instance.
- `aws_key_name` - The private key pair name on AWS to use.
- `aws_ami_user` - The user for the AMI to use to connect to the instance.
- `aws_private_key_file` - The full path to the private kye matching `aws_key_name` public key on AWS.
- `instance_count` - Number of Build Nodes to create.
- `instance_name_pattern` - Pattern to use when naming instances. Should include an integer format string i.e. builder%02d
- `chef_server_url` - Chef Server URL to register.
- `chef_organization` - Chef Server organization.
- `chef_environment` - Chef Environment to put node in.
- `delivery_enterprise` - Chef Delivery enterprise name.
- `run_list` - String with comma separated list of run_list items (role[blah] or recipe[blah]). If you override this you must include delivery_build somewhere in the expanded run_list.

Usage
-----

```js
# Setup Chef Build-Node(s)
module "chef_delivery_build_node" {
  source                  = "github.com/chef/tf_chef_delivery_build_node"
  aws_ami_id              = "ami-1255b321"
  aws_ami_user            = "AMI-USER"
  aws_flavor              = "c3.large"
  aws_subnet_id           = "subnet-b89dcee1"
  aws_security_groups_ids = "sg-6a0ac40d"
  instance_count          = 3
  instance_name_pattern   = "my-builder%02d"
  aws_key_name            = "KEY-NAME"
  aws_private_key_file    = ".keys/KEY-NAME.pem"
  chef_server_url         = "https://52.24.40.244/organizations/terraform"
  delivery_enterprise     = "terraform"
  chef_organization       = "terraform"
  chef_environment        = "_default"
  run_list                = "recipe[delivery_build]"
}
```

Outputs
=======

- `public_ips` - Comma-separated list of public_ids

A Terraform plan to install and configure Chef Delivery and its components:

LICENSE AND AUTHORS
===================
* [Salim Afiune](https://github.com/afiune) (<afiune@chef.io>)
* [Jon Morrow](https://github.com/jonsmorrow) (<jmorrow@chef.io>)

```text
Copyright:: 2016 Chef Software, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
