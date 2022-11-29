variable "token" {}
variable "psqldb_user_password" {}

variable "vpc_name" {
  default = "vpc-task-01"
}

variable "sn_name" {
  default = "sn-task-01"
}

variable "vm_name" {
  default = "vm01"
}

variable "psqlcl_name" {
  default = "psql-cl-01"
}

variable "psqldb_name" {
  default = "psql-db-01"
}

variable "tags" {
  type = map(any)
  default = {
    project   = "task01",
    createdby = "terraform",
    owner     = "slava"
  }
}
