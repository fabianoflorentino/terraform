[![BUILD IMAGE terraform 1.1.9](https://github.com/fabianoflorentino/terraform/actions/workflows/build-image.yml/badge.svg)](https://github.com/fabianoflorentino/terraform/actions/workflows/build-image.yml)

# A container image for run terraform tool

## **Usage**

| **Variable** | **Description** |
| --- | --- |
| $PWD | Current work directory with terraform code |

### **Local Usage**

```bash
# terraform 1.1.9

# Build
docker build --no-cache -t <IMAGE NAME>:<TAG> -f ./Dockerfile .

# Run
docker run -it --name terraform -v $PWD:/terraform -w /terraform --entrypoint "" fabianoflorentino/terraform:1.1.9 sh
```

### **Local Usage from Remote**

```bash
# terraform 1.1.9

# Pull (Download)
docker pull fabianoflorentino/terraform:1.1.9

# Run
docker run -it --name terraform -v $PWD:/terraform -w /terraform --entrypoint "" fabianoflorentino/terraform:1.1.9 sh
```

### **Github Actions**

#### **Terraform 1.1.9**

```yaml
---
name: BUILD IMAGE TERRAFORM 1.1.9

on:
  push:
    branches:
      - main
    paths-ignore:
      - 'README.md'
      - 'LICENSE'
      - 'docs/**'
      - '.github/**'

jobs:
  build:
    runs-on: ubuntu-latest
    name: Build Image
    steps:
      - 
        name: Checkout
        uses: actions/checkout@v2
      -
        name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1
      -
        name: Build and export
        uses: docker/build-push-action@v2
        with:
          file: Dockerfile
          context: .
          tags: fabianoflorentino/terraform:1.1.9
          outputs: type=docker,dest=/tmp/terraform119.tar
      -
        name: Upload artifact
        uses: actions/upload-artifact@v2
        with:
          name: terraform119
          path: /tmp/terraform119.tar
  test:
    runs-on: ubuntu-latest
    name: Test Image
    needs: build
    steps:
      -
        name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1
      -
        name: Download artifact
        uses: actions/download-artifact@v2
        with:
          name: terraform119
          path: /tmp
      -
        name: Load image
        run: |
          docker load --input /tmp/terraform119.tar
          docker image ls -a
      - 
        name: Test
        run: |
          docker run -i --rm --entrypoint "" $GITHUB_REPOSITORY:1.1.9 /bin/sh -c "terraform --version"

  push:
    runs-on: ubuntu-latest
    needs: test
    environment: DOCKERHUB
    name: Push Image
    steps:
      - 
        name: Checkout
        uses: actions/checkout@v2
      -
        name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1
      - 
        name: Login to DockerHub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      - 
        name: Build and push
        uses: docker/build-push-action@v2
        with:
          file: Dockerfile
          context: .
          push: true
          tags: fabianoflorentino/terraform:1.1.9
```
