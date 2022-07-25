module "deployments" {
  source = "../../resource_modules/deployments"
  app_name = var.app_name
}