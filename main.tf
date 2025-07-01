provider "aws" {
  region = "ap-southeast-1"
}

module "team_iam" {
  source = "./modules/iam"

  project_name   = var.project_name
  manager_users  = var.manager_users
  dev_users      = var.dev_users
  qa_users       = var.qa_users
  devops_users   = var.devops_users

}
