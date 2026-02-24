variable "layers" {
type = list(objects({
    # Required
    name = string
    source_path = string

    # Optional Build step (if provided, build runs before zip)
    build_command= optional(string)

    #Optional metadata
    description = optional(string)
    compatible_runtimes = optional(list(strings))
    compatible_architecture = optional(list(strings))
    kms_key_arn = optional(string)

 }) )
 description="necessary variables to build and create layers optionally"

 validation {
   condition = alltrue([
    for i in var.layers :
    length(trim(1.name)) > 0 && length(trim(1.source_path)) > 0
   ])

   error_message = "Each Layer must have a non-empty name and source_path."
 }
}

/* examples
each layer supports:
-optional build command
-Automatic zip creation
-automatic versioning
-Any runtime (Python, Node, Java,etc)

Example:

layers = [
#Python Layer (with build step)]

{
name  = "python-utils"
source_path = "${path.root}/layers/python-utils"

#optional: runs before zipping
build_commands = "pip install -r requitrement.txt -t python/"

compatible_runtimes = ["python3.12"]
description = "shared python utilities layer"
}.

#Node Layer (with build step)

{
name = "node-deps"
source_path = "${path.root}/layers/node-deps"
build_commands = "npm-install --production"
compatible_runtimes = ["nodejs20.x"] 
},

# Java layer(no build step

{
name = "java-lib"
source_path = "${path.root}/layer/java-lib"

compatible_runtimes = ["java21"]
compatible_architecture = ["arm64"]
}
]
*/


