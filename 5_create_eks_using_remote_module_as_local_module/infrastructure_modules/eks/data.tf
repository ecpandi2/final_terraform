locals {
  ## Key Pair ##
  key_pair_name = "eks-workers-keypair-${var.region_tag[var.region]}-${var.env}-${var.app_name}"
  # run "ssh-keygen" then copy public key content to public_key
  public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDv1pOKFu3wbldWpqQTzYWtiOEGDOdqNxv8z4mgwlMagKO0lGyuoJzWnAoCCYZeDM6itn7kvGFknHyZ2z5z0EiLGYjg0xCSwcdlBf/MURzrfXHTogx0WhiEA00qYrPUNxhRp5OLyi2MTILNOWzN1XBtUB4wJsQk6GaC5mIZkVmj7dNXdfgFGnIyQ7jca2MPDAbr8rAahDy76OtG7yjfr7mxL9FsF3S6qrX3Q6cTZ9LQJjIW5RCOOAO7vqfS0XrkoOhXGl+NqyRbKa1/x2ThuIM1zZ+/eBQN43eyRKqBEdQaKDaHu0Zg8YgALNP+RCUdmDy30/AF4TL3d0HkAI6BgvXJ root@master"

  ########################################
  ##  KMS for K8s secret's DEK (data encryption key) encryption
  ########################################
  k8s_secret_kms_key_name                    = "alias/cmk-${var.region_tag[var.region]}-${var.env}-k8s-secret-dek"
  k8s_secret_kms_key_description             = "Kms key used for encrypting K8s secret DEK (data encryption key)"
  k8s_secret_kms_key_deletion_window_in_days = "30"
  k8s_secret_kms_key_tags = merge(
    var.tags,
    tomap({
        "Name" = local.k8s_secret_kms_key_name
    })
  )
}

# current account ID
data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "k8s_api_server_decryption" {
  # Copy of default KMS policy that lets you manage it
  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
    }

    actions = [
      "kms:*"
    ]

    resources = ["*"]
  }

  # Required for EKS
  statement {
    sid    = "Allow service-linked role use of the CMK"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        module.eks_cluster.cluster_iam_role_arn, # required for the cluster / persistentvolume-controller
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root", 
      ]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        module.eks_cluster.cluster_iam_role_arn,                                                                                                 # required for the cluster / persistentvolume-controller to create encrypted PVCs
      ]
    }

    actions = [
      "kms:CreateGrant"
    ]

    resources = ["*"]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}