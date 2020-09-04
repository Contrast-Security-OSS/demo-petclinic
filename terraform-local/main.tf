#Terraform `provider` section is required since the `azurerm` provider update to 2.0+
provider "azurerm" {
  features {}
}

# Configure the Docker provider
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

data "external" "yaml" {
  program = [var.python_binary, "${path.module}/parseyaml.py"]
}

# Create a container
resource "docker_container" "spring-petclinic" {
  image = "contrastsecuritydemo/spring-petclinic:1.5.1"
  name  = "spring-petclinic"

  ports {
    internal = 8080
    external = 8081
  }

  env = [
    "JAVA_TOOL_OPTIONS=-Dcontrast.api.url=${data.external.yaml.result.url} -Dcontrast.api.api_key=${data.external.yaml.result.api_key} -Dcontrast.api.service_key=${data.external.yaml.result.service_key} -Dcontrast.api.user_name=${data.external.yaml.result.user_name} -Dcontrast.standalone.appname=${var.appname} -Dcontrast.server.name=${var.servername} -Dcontrast.server.environment=${var.environment} -Dcontrast.application.session_metadata=${var.session_metadata} -Dcontrast.application.tags=${var.apptags} -Dcontrast.server.tags=${var.servertags}"
  ]
}

