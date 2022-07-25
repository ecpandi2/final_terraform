module "eks_cluster" {
  source = "../../resource_modules/deployments"
  app_name = var.app_name
}