resource "fabric_environment" "environment" {
  count        = var.enable ? 1 : 0
  display_name = var.environment_name
  description  = var.environment_description
  workspace_id = var.workspace_id
}
