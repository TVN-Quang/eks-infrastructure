# Prefix variables for naming
variable "prefix_region_code" {
  type        = string
  description = "AWS Region that is prefixed to resource names (e.i apse1)."
}
variable "prefix_environment_code" {
  type        = string
  description = "Environment Code that is prefixed to resource names (e.i prod, dev, dev, lab)."
}
variable "prefix_environment_name" {
  type        = string
  description = "Enviroment Name that is prefixed to resource names."
}

# EKS cluster variables
variable "vpc_id" {
  type        = string
  description = "EKS cluster will be initialized inside this VPC."
}
variable "subnet_private_1" {
  type        = string
  description = "Private subnet 1 to be used for EKS Cluster."
}
variable "subnet_private_2" {
  type        = string
  description = "Private subnet 2 to be used for EKS Cluster."
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}

variable "eks_managed_node_groups" {
  type        = map(any)
  description = "Map of EKS managed node group definitions to create."
}

# variable "autoscaling_average_cpu" {
#   type        = number
#   description = "Average CPU threshold to autoscale EKS EC2 instances."
# }

variable "ebs_csi_driver_role_name" {
  type        = string
  description = "EKS EBS CSI Driver role name"
}

variable "ebs_csi_driver_policy_name" {
  type        = string
  description = "EKS EBS CSI Driver policy name"
}

variable "ebs_csi_driver_sa_name" {
  type        = string
  description = "EKS EBS CSI Driver service account name"
}

variable "ebs_csi_driver_sa_namespace" {
  type        = string
  description = "EKS EBS CSI Driver service account's namespace"
}

variable "ebs_csi_driver_policy_path" {
  type        = string
  description = "EKS EBS CSI Driver policy"
}

variable "cluster_security_group_additional_rules" {
  type = map(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    type        = string
    cidr_blocks = list(string)
  }))
}