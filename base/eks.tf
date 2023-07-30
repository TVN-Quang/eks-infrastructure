
# create EKS cluster
module "cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.4.2"

  cluster_name                    = var.cluster_name
  cluster_version                 = "1.23"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  vpc_id                          = var.vpc_id
  subnet_ids                      = [var.subnet_private_1, var.subnet_private_2]
  eks_managed_node_groups         = var.eks_managed_node_groups

  cluster_addons = {
    aws-ebs-csi-driver = {
      addon_version            = "v1.15.0-eksbuild.1"
      service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
    }
  }
  
  # allow connections from Jenkins ip
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules

  node_security_group_additional_rules = {
    # Only ussed for version 18.20.5 and earlier 
    # https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/2039#issuecomment-1099032289

    # allow connections from ALB security group
    ingress_allow_access_from_alb_sg = {
      type                     = "ingress"
      protocol                 = "-1"
      from_port                = 0
      to_port                  = 0
      source_security_group_id = aws_security_group.alb.id
    }

    # allow connections from EKS to the internet
    egress_all = {
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    # allow connections from EKS to EKS (internal calls)
    ingress_self_all = {
      protocol  = "-1"
      from_port = 0
      to_port   = 0
      type      = "ingress"
      self      = true
    }
  }
}

# create IAM role for AWS Load Balancer Controller, and attach to EKS OIDC
module "eks_ingress_iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 4.22.0"

  role_name                              = "load-balancer-controller-project-test"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.cluster.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

## role EBS CSI Driver
data "aws_iam_policy_document" "oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.cluster.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:${var.ebs_csi_driver_sa_name}"]
    }

    principals {
      identifiers = [module.cluster.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_policy" "eks_ebs_csi_driver" {
  name = var.ebs_csi_driver_policy_name

  policy = file("${path.root}/${var.ebs_csi_driver_policy_path}")
}

resource "aws_iam_role" "eks_ebs_csi_driver" {
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role_policy.json
  name               = var.ebs_csi_driver_role_name
}

resource "aws_iam_role_policy_attachment" "eks_ebs_csi_driver_attach" {
  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = aws_iam_policy.eks_ebs_csi_driver.arn
}
