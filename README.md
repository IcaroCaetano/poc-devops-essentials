## Vamos montar um projeto Java 21 com Spring Boot Hello World, e integrar as ferramentas:

- ✅ Docker - (empacotar a aplicação)

- ✅ Jenkins (CI/CD)

- ✅ Helm (gerenciar o deployment no Kubernetes)

- ✅ OpenTofu (infra como código – fork do Terraform)

- ✅ Minikube ou outro gerenciador de cluster Kubernetes (cluster local Kubernetes)

- ✅ Prometheus + Grafana (monitoramento)

- ✅ Spring Boot com Actuator e endpoint /hello


## ✅ Instalar o Chocolatey (caso não tenha)
Abra o PowerShell como administrador

Execute este comando:

```shell

Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.Net.ServicePointManager]::SecurityProtocol = `
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Depois disso, digite choco -v novamente para confirmar.

```shell

choco -v
```
## ✅ Instalar o Docker

````shell

choco install docker-desktop
````

Verificar instalação:

````shell

docker --version
````

## ✅ Instalar o Minikube

````shell

choco install minikube
````
Verficar instalação:

````shell

minikube version
````

## ✅ Instalar o kubectl

`````shell

choco install kubernetes-cli
`````
    
Verificar instalação:

````shell

kubectl version --client
````

## ✅ Iniciar o cluster

Podemos iniciar o Minikube com o driver Docker, VirtualBox ou Hyper-V.

Com Docker (mais comum com Windows + WSL2):

- Primeiro execute o Docker desktop

- Verifique se o Daemon está ativo:

````shell

docker info
````

## 🧩 Em conjunto:

Você cria sua aplicação Java (ex: Spring Boot).

Empacota em um Docker image.

Usa o Minikube para rodar um cluster local.

Usa o Helm para instalar e gerenciar sua aplicação nesse cluster de forma prática e reutilizável.

- Iniciar o minikuber

````shell

minikube start --driver=docker
````

## ✅ Após iniciar o Minikube com sucesso:

Teste se o cluster está rodando:

````shell

kubectl get nodes
````

Habilite o Ingress (caso vá expor sua aplicação localmente):

````shell

minikube addons enable ingress
````

Build da imagem:

````shell

minikube image build -t springboot-app:latest .

````

## ✅ Instalação do Helm Chart:

````shell

helm install springboot-app ./helm/springboot-chart

````

Acesso à aplicação:

````shell

minikube service springboot-app

````

## Estrutura do Helm 

````shell

helm/
└── springboot-chart/
    ├── Chart.yaml
    └── templates/
        ├── deployment.yaml
        └── service.yaml

````

## ✅ Instalação do Opentofu Para Windows (via Chocolatey):

````shell

choco install opentofu
````

Verifique:

````shell

tofu version
````

## Estrutura do tofu

````shell
project-root/
├── helm/
│   └── springboot-chart/
├── tofu/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── values.yaml

````

