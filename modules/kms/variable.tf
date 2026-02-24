variable "tags" {
    description = "tags to apply to all resources"
    type = map(string)
    default = {}
      
    }
  
variable "key_to_be_multi_region"{
    description = "Boolean to specify whether the KMS key should be multi-region or not"
    type = bool
    default = false
       
  
}