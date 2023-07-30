# create EKS cluster
module "base" {
  source = "./base/"
  cluster_name = var.cluster_name
  # network.tf
  vpc_id                  = var.vpc_id
  subnet_private_1        = var.subnet_private_1
  subnet_private_2        = var.subnet_private_2
  eks_managed_node_groups = var.eks_managed_node_groups
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules

  #***************** EBS_CSI_DRIVER *****************
  ebs_csi_driver_role_name    = var.ebs_csi_driver_role_name
  ebs_csi_driver_policy_name  = var.ebs_csi_driver_policy_name
  ebs_csi_driver_sa_name      = var.ebs_csi_driver_sa_name
  ebs_csi_driver_sa_namespace = var.ebs_csi_driver_sa_namespace
  ebs_csi_driver_policy_path  = var.ebs_csi_driver_policy_path
  # tags & naming
  prefix_region_code      = var.prefix_region_code
  prefix_environment_code = var.prefix_environment_code
  prefix_environment_name = var.prefix_environment_name

}

