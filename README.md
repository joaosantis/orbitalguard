# OrbitalGuard — Global Solution FIAP 2025

> **Tecnologia espacial salvando vidas na Terra.**

Sistema inteligente de monitoramento e prevenção de desastres naturais (enchentes, queimadas e deslizamentos) utilizando dados de satélite, sensores IoT e inteligência artificial.

---

## Equipe

| RM | Nome |
|---|---|
| RM555287 | João Santis |

---

## Descrição da Solução

O **OrbitalGuard** conecta a exploração espacial com problemas reais na Terra. Satélites coletam dados climáticos e orbitais que são processados por uma IA para identificar riscos de desastres naturais. A API centraliza alertas em tempo real, permitindo que autoridades e cidadãos tomem decisões antes que o desastre aconteça.

**Problema resolvido:** cidades brasileiras sofrem com enchentes, deslizamentos e queimadas por falta de monitoramento preventivo eficiente.

**ODS da ONU atendidos:** ODS 9 (Indústria e Infraestrutura), ODS 11 (Cidades Sustentáveis), ODS 13 (Ação Climática).

---

## Arquitetura Macro

```
┌─────────────────────────────────────────────────────────────┐
│                        AZURE VM                             │
│                                                             │
│   ┌──────────────────────────────────────────────────────┐  │
│   │              Docker Compose Network                  │  │
│   │                 (orbitalguard-net)                   │  │
│   │                                                      │  │
│   │  ┌──────────────────────┐  ┌──────────────────────┐  │  │
│   │  │  orbitalguard-api    │  │  orbitalguard-mysql   │  │  │
│   │  │  rm555287            │  │  rm555287             │  │  │
│   │  │                      │  │                       │  │  │
│   │  │  Spring Boot 3.2     │──▶  MySQL 8.0            │  │  │
│   │  │  Java 17             │  │                       │  │  │
│   │  │  USER: orbital       │  │  Volume nomeado:      │  │  │
│   │  │  WORKDIR: /orbital   │  │  orbitalguard_data    │  │  │
│   │  │  PORT: 8080          │  │  PORT: 3306           │  │  │
│   │  └──────────────────────┘  └──────────────────────┘  │  │
│   └──────────────────────────────────────────────────────┘  │
│                                                             │
│   Portas abertas: 8080 (API), 3306 (MySQL)                  │
└─────────────────────────────────────────────────────────────┘
         ▲                              ▲
         │                              │
   Usuário / App Mobile           Satélites / IoT ESP32
```

---

## Tecnologias

| Camada | Tecnologia |
|---|---|
| Linguagem | Java 17 |
| Framework | Spring Boot 3.2 |
| ORM | Spring Data JPA |
| Banco de Dados | MySQL 8.0 |
| Containerização | Docker + Docker Compose |
| Cloud | Microsoft Azure (VM Ubuntu 24.04) |

---

## Estrutura do Projeto

```
orbitalguard/
├── orbitalguard-api/
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/main/java/br/com/orbitalguard/
│       ├── OrbitalGuardApplication.java
│       ├── controller/
│       │   ├── CidadeController.java
│       │   └── AlertaController.java
│       ├── model/
│       │   ├── Cidade.java
│       │   └── Alerta.java
│       └── repository/
│           ├── CidadeRepository.java
│           └── AlertaRepository.java
├── orbitalguard-mysql/
│   └── init.sql
├── docker-compose.yml
└── README.md
```

---

## Banco de Dados

Duas tabelas com relacionamento (FK):

**cidade** — cidades monitoradas pelo sistema
- `id`, `nome`, `estado`, `latitude`, `longitude`, `populacao`

**alerta** — alertas gerados por análise orbital/satelital
- `id`, `cidade_id` (FK → cidade), `nivel`, `descricao`, `tipo_desastre`, `data_hora`, `ativo`

---

## Endpoints da API

Base URL: `http://<IP_DA_VM>:8080`

### Cidades
| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/cidades` | Lista todas as cidades |
| GET | `/cidades/{id}` | Busca cidade por ID |
| POST | `/cidades` | Cadastra nova cidade |
| PUT | `/cidades/{id}` | Atualiza cidade |
| DELETE | `/cidades/{id}` | Remove cidade |

### Alertas
| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/alertas` | Lista todos os alertas |
| GET | `/alertas/ativos` | Lista apenas alertas ativos |
| GET | `/alertas/{id}` | Busca alerta por ID |
| GET | `/alertas/cidade/{cidadeId}` | Alertas de uma cidade |
| POST | `/alertas` | Cria novo alerta |
| PUT | `/alertas/{id}` | Atualiza alerta |
| DELETE | `/alertas/{id}` | Remove alerta |

---

## How To — Executar o Projeto (do clone à nuvem)

### Pré-requisitos

- Git instalado
- Docker e Docker Compose instalados
- (Nuvem) VM Azure com Ubuntu 24.04 e portas 8080 e 3306 abertas no NSG

### 1. Clonar o repositório

```bash
git clone https://github.com/joaosantis/orbitalguard.git
cd orbitalguard
```

### 2. Subir os containers em background

```bash
docker compose up -d --build
```

Aguarde ~40 segundos para o MySQL inicializar completamente.

### 3. Verificar se os containers estão rodando

```bash
docker ps
```

### 4. Ver logs dos containers

```bash
# Logs do banco
docker logs orbitalguard-mysql-rm555287

# Logs da API
docker logs orbitalguard-api-rm555287
```

### 5. Testar a API

```bash
# Listar cidades
curl http://localhost:8080/cidades

# Listar alertas ativos
curl http://localhost:8080/alertas/ativos

# Criar novo alerta
curl -X POST http://localhost:8080/alertas \
  -H "Content-Type: application/json" \
  -d '{"cidade":{"id":1},"nivel":"ALTO","descricao":"Novo alerta orbital","tipoDesastre":"ENCHENTE"}'
```

### 6. Acessar o container da API (demonstração exec)

```bash
docker container exec -it orbitalguard-api-rm555287 sh
# Dentro do container:
pwd
ls -l
whoami
exit
```

### 7. Acessar o container do banco (demonstração exec + SELECT)

```bash
docker container exec -it orbitalguard-mysql-rm555287 bash
# Dentro do container:
pwd
ls -l
whoami
mysql -u orbital -porbital123 orbitalguard_db
# Dentro do MySQL:
SELECT * FROM cidade;
SELECT * FROM alerta;
SELECT c.nome, a.nivel, a.tipo_desastre FROM alerta a JOIN cidade c ON a.cidade_id = c.id;
exit
exit
```

### 8. Parar os containers

```bash
docker compose down
```

### 9. Remover também o volume (reset completo)

```bash
docker compose down -v
```

---

## Configuração na Azure VM

```bash
# Instalar Docker na VM Ubuntu
sudo apt update
sudo apt install -y docker.io docker-compose-v2
sudo usermod -aG docker $USER
newgrp docker

# Clonar e executar
git clone https://github.com/joaosantis/orbitalguard.git
cd orbitalguard
docker compose up -d --build
```

---

## Autor

**João Santis** — RM555287  
FIAP — Global Solution 2025 — DevOps Tools & Cloud Computing
