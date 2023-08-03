
variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(any)

}

# variable "subnet_id" {
#   type = string

# }

variable "psubnet_id" {
  type = list(any)

}

variable "target_group_arns" {}

