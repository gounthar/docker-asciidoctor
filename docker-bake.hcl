variable "IMAGE_VERSION" {
  default = ""
}

variable "IMAGE_NAME" {
  default = "asciidoctor"
}

group "all" {
  targets = [
    "asciidoctor-minimal",
    "erd-builder",
    "asciidoctor"
  ]
}

target "asciidoctor-minimal" {
  dockerfile = "Dockerfile"
  context = "."
  target = "main-minimal"
}

// This image is only used for intermediate steps
target "erd-builder" {
  dockerfile = "Dockerfile"
  context = "."
  target = "erd-builder"
}

target "asciidoctor" {
  dockerfile = "Dockerfile"
  context = "."
  target = "main"
  tags = [
    "${IMAGE_NAME}",
    notequal("", IMAGE_VERSION) ? "${IMAGE_NAME}:${IMAGE_VERSION}" : "", // Only used when deploying on a tag
    notequal("", IMAGE_VERSION) ? "${IMAGE_NAME}:${element(split(".", IMAGE_VERSION), 0)}" : "", // Only used when deploying on a tag (1 digit)
    notequal("", IMAGE_VERSION) ? "${IMAGE_NAME}:${element(split(".", IMAGE_VERSION), 0)}.${element(split(".", IMAGE_VERSION), 1)}" : "", // Only used when deploying on a tag (2 digits)
  ]
}
