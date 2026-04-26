# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Contexto: Taller 2 CI/CD

Este es el **ops repo** del Taller 2 universitario de CI/CD sobre el proyecto CircleGuard.
El **dev repo** es `circle-guard-public`, ubicado en la misma carpeta padre (`Taller2-Mio/`).

### Arquitectura GitOps
```
Taller2-Mio/
├── circle-guard-public/   ← dev repo: código fuente, Dockerfiles, tests
└── circle-guard-ops/      ← este repo: Terraform, K8s manifests, Jenkinsfiles
```

### Flujo entre repos
```
Dev repo push
  → Jenkinsfile ligero (build + test + docker push a ACR con tag BUILD_NUMBER)
  → commit en este repo actualizando imagen tag en k8s/services/*.yaml
    → dispara Jenkinsfile de este repo
      → kubectl apply en AKS namespace correspondiente
```

## Stack tecnológico

| Componente | Tecnología | Detalle |
|---|---|---|
| Cloud | Azure | Créditos estudiante ($100) |
| Infra como código | Terraform | Provisiona AKS + ACR |
| Kubernetes | AKS | 3 namespaces: dev / stage / prod |
| Registry | ACR | Azure Container Registry |
| Jenkins | Docker Compose local | Corre en la máquina del desarrollador, NO en Azure VM |
| Patrón | Spin up / down | `terraform apply` al trabajar, `terraform destroy` al terminar |

## Estructura de este repo

```
circle-guard-ops/
├── terraform/
│   ├── main.tf              ← AKS cluster
│   ├── acr.tf               ← Azure Container Registry
│   ├── namespaces.tf        ← namespaces circleguard-dev/stage/prod
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── k8s/
│   ├── infrastructure/
│   │   ├── postgres.yaml    ← PostgreSQL (con PVC)
│   │   ├── neo4j.yaml       ← Neo4j
│   │   ├── redis.yaml       ← Redis
│   │   └── kafka.yaml       ← Kafka + Zookeeper
│   └── services/
│       ├── auth-service.yaml
│       ├── identity-service.yaml
│       ├── promotion-service.yaml
│       ├── notification-service.yaml
│       ├── form-service.yaml
│       └── gateway-service.yaml
└── jenkins/
    ├── docker-compose.yml   ← Jenkins local
    ├── Jenkinsfile.dev      ← build + unit tests + deploy a circleguard-dev
    ├── Jenkinsfile.stage    ← build + unit + integration + deploy a circleguard-stage
    └── Jenkinsfile.master   ← pipeline completo + Release Notes + deploy a circleguard-prod
```

## Comandos de Terraform

```bash
cd terraform/

# Inicializar (primera vez)
terraform init

# Ver qué va a crear
terraform plan -var-file="terraform.tfvars"

# Provisionar infra (spin up)
terraform apply -var-file="terraform.tfvars"

# Destruir infra (spin down - ahorra créditos)
terraform destroy -var-file="terraform.tfvars"

# Obtener kubeconfig tras el apply
az aks get-credentials --resource-group circleguard-rg --name circleguard-aks
```

## Comandos de Jenkins (local)

```bash
cd jenkins/

# Levantar Jenkins
docker-compose up -d

# Jenkins disponible en: http://localhost:8080

# Bajar Jenkins
docker-compose down
```

## Comandos de Kubernetes

```bash
# Aplicar infraestructura en un namespace
kubectl apply -f k8s/infrastructure/ -n circleguard-dev

# Aplicar servicios en un namespace
kubectl apply -f k8s/services/ -n circleguard-dev

# Ver estado de pods
kubectl get pods -n circleguard-dev

# Actualizar imagen de un servicio
kubectl set image deployment/auth-service auth=<ACR_URL>/circleguard-auth:<TAG> -n circleguard-dev
```

## 6 servicios del dev repo que se despliegan aquí

| Servicio | Puerto | Imagen ACR |
|---|---|---|
| Auth | 8180 | circleguard-auth |
| Identity | 8083 | circleguard-identity |
| Promotion | 8088 | circleguard-promotion |
| Notification | 8082 | circleguard-notification |
| Form | 8086 | circleguard-form |
| Gateway | 8087 | circleguard-gateway |

## Estado del taller (actualizar al avanzar)

- [x] Estructura del ops repo creada
- [ ] `terraform.tfvars` creado con credenciales reales (NO commitear, está en .gitignore)
- [ ] `terraform apply` ejecutado al menos una vez
- [ ] Jenkins configurado con credenciales de Azure y GitHub
- [ ] Pipelines dev/stage/master probados
- [ ] K8s deployments verificados

## Archivos que NUNCA se deben commitear

- `terraform/terraform.tfvars` (tiene subscription ID, secrets)
- `terraform/.terraform/`
- `terraform/*.tfstate` y `terraform/*.tfstate.backup`
- `jenkins/secrets/` o cualquier archivo con contraseñas
