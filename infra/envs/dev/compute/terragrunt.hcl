include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

dependency "vpc" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/compute"
}

inputs = {
  instance_type = "t3.micro"
  vpc_id        = dependency.vpc.outputs.vpc_id
  subnet_id     = dependency.vpc.outputs.private_subnet_ids[0]
  ami           = "ami-07695fdb89e41b9f8"  # amazonlinux2023 ami
}