output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

