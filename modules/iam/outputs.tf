output "user_credentials" {
  value = var.enable_password_login ? {
    for user, profile in aws_iam_user_login_profile.login :
    user => {
      login_url = "https://${var.project_name}.signin.aws.amazon.com"
      username  = user
      password  = profile.encrypted_password
    }
  } : null
  sensitive = true
}
