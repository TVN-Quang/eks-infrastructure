output "cluster_id" {
  value = module.cluster.cluster_id
}

output "cluster_name" {
  value = module.cluster.cluster_name
}

output "cluster_oidc_provider_arn" {
  value = module.cluster.oidc_provider_arn
}

output "eks_ebs_csi_driver_arn" {
  value = aws_iam_role.eks_ebs_csi_driver.arn
}