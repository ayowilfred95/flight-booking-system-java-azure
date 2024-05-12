resource "null_resource" "build_and_push_image" {
  provisioner "local-exec" {
    command = "docker build -t flightbookingsystemsample ."
  }

  provisioner "local-exec" {
    command = "docker tag flightbookingsystemsample ${var.AZ_CONTAINER_REGISTRY}.azurecr.io/flightbookingsystemsample"
  }

  provisioner "local-exec" {
    command = "docker push ${var.AZ_CONTAINER_REGISTRY}.azurecr.io/flightbookingsystemsample"
  }
}
