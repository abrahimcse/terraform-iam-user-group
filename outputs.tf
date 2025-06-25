output "user_credentials" {
  value       = module.team_iam.user_credentials
  sensitive   = true
  description = "Initial user credentials (password available for 1 hour)"
}
