# IAM Wokrer Node Instance Profile 
output "instance_profile" {
  value = aws_iam_instance_profile.worker.name
}

# IAM Role Master's ARN
output "master_arn" {
  value = aws_iam_role.master.arn
}

# IAM Role Worker's ARN
output "worker_arn" {
  value = aws_iam_role.worker.arn
}

output "argocd_irsa_role_arn" {
  value = aws_iam_role.argocd_irsa_role.arn
}

output "prometheus_irsa_role_arn" {
  value = aws_iam_role.prometheus_irsa_role.arn
}
