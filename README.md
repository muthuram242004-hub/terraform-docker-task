# Task 3 – Infrastructure as Code with Terraform (Docker)

## Prerequisites
- Docker running (`docker ps` works)
- Terraform installed (`terraform -version`)
- Windows / Docker Desktop: in `main.tf` change the provider host to `npipe:////./pipe/docker_engine`

## Steps (run inside this folder)

| Step | Command | What it does |
|---|---|---|
| a | write `main.tf` | Declares the Docker provider, an `nginx` image and a container on port 8000 |
| b | `terraform init` | Downloads the `kreuzwerker/docker` provider, creates `.terraform/` and `.terraform.lock.hcl` |
| d | `terraform plan` | Shows `Plan: 2 to add, 0 to change, 0 to destroy` – nothing is created yet |
| b | `terraform apply` (type `yes`) | Pulls nginx and starts container `tf-nginx` |
| – | `docker ps` / open http://localhost:8000 | Verify the container is running (nginx welcome page) |
| e | `terraform state list` | Lists `docker_container.web` and `docker_image.web` |
| e | `terraform state show docker_container.web` | Full recorded attributes (ID, ports, IP, …) |
| c | `terraform destroy` (type `yes`) | Removes the container; `Resources: 2 destroyed` |

To save your own logs:

```bash
terraform init    2>&1 | tee -a execution_logs.txt
terraform plan    2>&1 | tee -a execution_logs.txt
terraform apply -auto-approve   2>&1 | tee -a execution_logs.txt
terraform state list            2>&1 | tee -a execution_logs.txt
terraform state show docker_container.web 2>&1 | tee -a execution_logs.txt
terraform destroy -auto-approve 2>&1 | tee -a execution_logs.txt
```

## Outcome
The infrastructure (a container) is described as code, previewed with `plan`, created with `apply`,
tracked in `terraform.tfstate`, and removed with `destroy` — the same declarative cycle used for cloud resources.
