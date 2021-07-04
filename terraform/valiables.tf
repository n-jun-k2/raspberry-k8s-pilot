variable "work-space-name" {
  type = string
  default = "default-namespace"
  description = "namespace name."
}

variable "debug-command" {
  type = list(string)
  default = ["tail", "-f", "/dev/null"]
}
