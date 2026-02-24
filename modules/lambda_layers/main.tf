terraform {
  
required_providers {
  archive = {
    source = "hashicorp/archive"
  }
}
}

#conditional buildsetup
resource "null_resource" "build" {
  for_each = {
    for layer in var.layers :
    layer.name => layer
    if try(layer.build_command, null) != null
  }
  triggers = {
    # Rebuild if source file change
    source_hash = sha256(join("",fileset(each.value.source_path,"**")))
    build_cmd = each.value.build_command
  }

  provisioner "local-exec" {
    working_dir = each.value.source_path
    command = each.value.build_command
  }
  }

  # Zip layer after build (or directly if no build)

  data "archive_file" "layers_zip" {
    for_each = {
      for layer in var.layers :
      layer.name => layer
    }
    type = "zip"
    source_dir = each.value.source_path
    output_path = "${path.module}/build/${each.key}.zip"

    depends_on = [
      null_resource.build
     ]
    }
    
  # create lambda layer versions

  resource "aws_lambda_layer_version" "this" {
    for_each = data.archive_file.layers_zip

    layer_name = each.key

    filename = each.value.output_path
    source_code_hash = each.value.output_base64sha256

    compatible_runtimes = lookup(
      {for i in var.layers : i.name => i.compatible_runtimes},
      each.key,
      null

    )
    
    compatible_architectures = lookup(
      {for i in var.layers : i.name => i.compatible_architecture} ,
      each.key,
      null
    )
    
    description = lookup(
      {for i in var.layers : i.name => i.description},
      each.key,
      null
    
    )


    lifecycle {
      create_before_destroy = true
    }
  }
