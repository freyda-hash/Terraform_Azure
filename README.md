# Terraform_Azure

Ce dépôt présente une infrastructure **Azure en Infrastructure as Code (IaC)** construite avec **Terraform**. Il inclut un environnement d'infrastructure (Réseau, Subnet, etc.) et un environnement d'applications (Azure Container Apps) pour déployer un ensemble de microservices (Online Boutique) en **dev** et **prod**.

## 🚀 Objectifs du projet

- Démontrer une architecture cloud Azure complète : réseau, sécurité, observabilité et déploiement de microservices.
- Utiliser des **modules Terraform réutilisables** (ex : `modules/containerapp`) pour standardiser les déploiements.
- Isoler les environnements **dev** / **prod** (états distants séparés, noms de ressources, tags).
- Montrer les bonnes pratiques Terraform : backend distant, variables, tests (tftest), RBAC, identités managées, Key Vault.

---

## 🗂️ Structure du dépôt

```
apps/                       # Infrastructure des applications (online-boutique)
  online-boutique/
    dev/                    # Environnement DEV
    prod/                   # Environnement PROD

infra/                      # Infrastructure réseau / infra commune
  dev/                      # Environnement DEV
  prod/                     # Environnement PROD

modules/                    # Modules Terraform réutilisables
  containerapp/             # Module pour déployer un Azure Container App
```

### ✅ Ce que fait chaque dossier

- **infra/** : provisionne le réseau (Resource Group, VNet, Subnet) et prépare le subnet pour Azure Container Apps.
- **apps/online-boutique/** : déploie l’application Online Boutique composée de plusieurs microservices conteneurisés sur Azure Container Apps.
- **modules/containerapp/** : module Terraform qui définit un `azurerm_container_app` configurable (image, CPU/Mem, ingress, variables d'environnement, secrets Key Vault).

---

## 🔥 Points forts techniques 

- **Séparation dev/prod** avec backends Terraform distincts (`backend.tf`) et tags d’environnement.
- **Modules réutilisables** : un seul module `containerapp` est utilisé pour déployer tous les microservices.
- **Sécurité** : utilisation de **Managed Identity**, **Key Vault** (RBAC), et *secrets* injectés dans les apps via Key Vault.
- **Observabilité** : chaque environnement a son propre **Log Analytics Workspace**.
- **Infrastructure as Code testée** : tests `tftest` dans chaque dossier (ex : `infra/dev/tests/basic.tftest.hcl`, `modules/containerapp/tests/basic.tftest.hcl`).
- **Configuration déclarative** des microservices via une map (`var.microservices`) pour faciliter l’ajout et l’extension.

---

## 🛠️ Déploiement (Quick Start)

### Prérequis

- Terraform (>= 1.5)
- Compte Azure + `az login`
- Subscription configurée (`az account set --subscription <id>`)

### 1) Déployer l’infrastructure (infra)

```bash
cd infra/dev
terraform init
terraform plan
terraform apply
```

> Pour PROD, changez `dev` en `prod` et vérifiez le backend et les noms de ressources.

### 2) Déployer les applications (online-boutique)

1. Aller dans le dossier de l’environnement souhaité (dev ou prod)
2. `terraform init`
3. `terraform plan`
4. `terraform apply`

```bash
cd apps/online-boutique/dev
terraform init
terraform apply
```

## 🧪 Tests automatiques (tftest)

Chaque stack inclut un test `tftest` qui vérifie des invariants simples (noms, paramètres, délégation...).

Exemple :

```bash
# depuis infra/dev
tftest run
```

---

## 🧩 Modules clés

### `modules/containerapp`

Ce module standardise le déploiement d’un Azure Container App en s’appuyant sur :

- Image Docker configurable
- Réseau (ingress internal/external)
- CPU/Mémoire et scalabilité (min/max replicas)
- Identité managée (UserAssigned)
- Gestion des secrets via Key Vault

---

## 🧭 Amélioration future

- Externaliser les variables sensibles (secrets, configurations) dans un Key Vault partagé et utiliser `azurerm_key_vault_secret`.
- Ajouter des pipelines CI/CD (GitHub Actions / Azure DevOps) pour valider les `plan` et exécuter les `tftest`.
- Ajouter des modules pour la gestion des réseaux (NSG), des WAF ou d’un ingress controller

---


