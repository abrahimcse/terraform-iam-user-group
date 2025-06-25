locals {
  all_users = distinct(concat(
    var.manager_users,
    var.dev_users,
    var.qa_users,
    var.devops_users,
    var.dev_qa_users
  ))
}

resource "aws_iam_group" "groups" {
  for_each = toset(["managers", "developers", "qa", "devops"])
  name     = "${var.project_name}-${each.key}"
}

resource "aws_iam_user" "users" {
  for_each = toset(local.all_users)
  name     = each.key
  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_user_login_profile" "login" {
  for_each = var.enable_password_login ? toset(local.all_users) : []

  user                    = each.value
  password_length         = 20
  password_reset_required = true

  depends_on = [aws_iam_user.users]
}

resource "aws_iam_user_group_membership" "memberships" {
  for_each = aws_iam_user.users

  user   = each.value.name
  groups = compact([
    contains(var.manager_users, each.key) ? aws_iam_group.groups["managers"].name : null,
    contains(var.dev_users, each.key) ? aws_iam_group.groups["developers"].name : null,
    contains(var.qa_users, each.key) ? aws_iam_group.groups["qa"].name : null,
    contains(var.devops_users, each.key) ? aws_iam_group.groups["devops"].name : null
  ])
}

# Policy attachments for each group
resource "aws_iam_group_policy_attachment" "managers" {
  group      = aws_iam_group.groups["managers"].name
  policy_arn = aws_iam_policy.manager_policy.arn
}

resource "aws_iam_group_policy_attachment" "developers" {
  group      = aws_iam_group.groups["developers"].name
  policy_arn = aws_iam_policy.dev_policy.arn
}

resource "aws_iam_group_policy_attachment" "devops" {
  group      = aws_iam_group.groups["devops"].name
  policy_arn = aws_iam_policy.devops_policy.arn
}

resource "aws_iam_group_policy_attachment" "qa" {
  group      = aws_iam_group.groups["qa"].name
  policy_arn = aws_iam_policy.qa_policy.arn
}

resource "aws_iam_policy" "manager_policy" {
  name        = "${var.project_name}-manager-policy"
  policy      = file("${path.module}/policies/manager_policy.json")
}

resource "aws_iam_policy" "dev_policy" {
  name        = "${var.project_name}-dev-policy"
  policy      = file("${path.module}/policies/dev_policy.json")
}

resource "aws_iam_policy" "devops_policy" {
  name        = "${var.project_name}-devops-policy"
  policy      = file("${path.module}/policies/devops_policy.json")
}

resource "aws_iam_policy" "qa_policy" {
  name        = "${var.project_name}-qa-policy"
  policy      = file("${path.module}/policies/qa_policy.json")
}
