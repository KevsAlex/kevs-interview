#--------------------------
# Parameter Store
#---------------------------
module "parameter_store" {
  source       = "./modules/parameter_store"
  environment  = var.environment
  parameters   = local.ecs_parameters
  project-name = local.project_name
}

#--------------------------
# ECR Repositories config
#---------------------------
module "ecr" {
  source   = "./modules/ecr"
  services = local.services
}

#--------------------------
# Manage ALB
#---------------------------
module "LOAD_BALANCER" {
  source = "./modules/LOAD_BALANCER"

  services = local.services

  environment = var.environment
  vpc-id      = var.vpc-id

  load-balancer-name = "interview"
  public-subnets = []
  private-subnets    = ["subnet-02e065c37f823267e","subnet-0ffc7d0de8da60713"]
}

#--------------------------
# ECS Config
#---------------------------
module "ecs" {
  source = "./modules/ecs"

  services = local.services
  app-name = local.project_name

  environment    = var.environment
  region         = data.aws_region.current.name

  private-subnets  = ["subnet-02e065c37f823267e","subnet-0ffc7d0de8da60713"]
  target-groups    = module.LOAD_BALANCER.network-target-groups
  vpc-id           = var.vpc-id
  #project-name     = "refactor"


  depends_on = [module.parameter_store]
}

#--------------------------
# Configuracion de Pipeline para proyectos de terraform
#---------------------------
module "codepipeline" {
  source             = "./modules/codepipeline"
  AWS_ACCOUNT_ID     = data.aws_caller_identity.current.account_id
  codestar-arn       = var.codestar-arn
  environment        = var.environment
  project-name       = "interview"
  region             = var.region
  terraform-services = local.terraform-services
  ecs-cluster-name   = "${local.project_name}-cluster-${var.environment}"
  private-subnets    = ["subnet-02e065c37f823267e","subnet-0ffc7d0de8da60713"]
  vpc-id             = var.vpc-id

  services           = local.services
  depends_on = [module.ecs]
}