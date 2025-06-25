variable "project_name" {
  type = string
}

variable "manager_users" {
  type = list(string)
}

variable "dev_users" {
  type = list(string)
}

variable "qa_users" {
  type = list(string)
}

variable "devops_users" {
  type = list(string)
}

variable "dev_qa_users" {
  type = list(string)
}

variable "enable_password_login" {
  type        = bool
  default     = true
  description = "Whether to create console login profiles"
}
