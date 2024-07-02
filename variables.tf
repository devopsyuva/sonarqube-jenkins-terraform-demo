variable "inst_type" {
  description = "Multiple instance types"
  type        = list(string)
  default     = ["t3.micro", "t2.small", "t2.medium"]
}
variable "inst_count" {
  description = "No of EC2 instances to be launched"
  type        = number
  default     = 1
}
variable "ec2_instance_tags" {
  description = "Default tags to be used"
  type        = map(string)
  default = {
    "Name"        = "webapp"
    "Environment" = "Dev"
    "Type"        = "Application"
  }
}

variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  default     = "ami-053b0d53c279acc90"

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "az_name" {
  description = "Provide AZ name as per Region to launch Instance"
  default = "us-east-1a"
}

variable "keyname" {
  description = "Provide SSH key name"
  default = "virginia_sudhams"
}
