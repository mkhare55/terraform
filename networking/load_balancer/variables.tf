variable "tags" {
  description = "Tag map for the resource"
  type        = map(string)
  default     = {}
}

variable "vpc_security_group_ids" {
  type = list
  
}

variable "psubnet_id" {
  type = list
  
}

variable "vpc_id" {
    type = string
}

