variable "vcd_user" {}
variable "vcd_pass" {}
variable "vcd_org" {
    default = "YourOrgGoesHere"
}
variable "vcd_vdc" {
    default = "YourVDCGoesHere"
}
variable "vcd_url" {
    default = "https://expedient.cloud/api"
}
variable "vcd_max_retry_timeout" {
    default = 240
}
