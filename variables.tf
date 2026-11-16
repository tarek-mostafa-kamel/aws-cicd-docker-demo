variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "cicd-demo"
}

variable "instance_type" {
  description = "EC2 instance type (t3.micro is free-tier eligible in most regions)"
  type        = string
  default     = "t3.micro"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR form, e.g. 203.0.113.10/32. Only this IP can SSH."
  type        = string
}

variable "public_key_path" {
  description = "Path to your SSH PUBLIC key (.pub)"
  type        = string
  default     = "~/.ssh/cicd-key.pub"
}

variable "repo_url" {
  description = "HTTPS URL of your public GitHub repo (cloned onto the server)"
  type        = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
