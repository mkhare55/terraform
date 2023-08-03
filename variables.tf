variable "ports" {
  type = list(number)
}

variable "web_image_id" {
  type = string
}

variable "compute_image_id" {
  type = string
}

variable "mid-tier_image_id" {
  type = string
}

variable "compute_instance_type" {
  type = string
}

variable "mid-tier_instance_type" {
  type = string
}

variable "web_instance_type" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}



