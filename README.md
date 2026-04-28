# DimDim Bank — CP2

Aplicação bancária fictícia desenvolvida para o CP2, composta por uma API REST em Spring Boot, banco de dados MySQL e frontend web, todos orquestrados via Docker Compose em uma VM Azure.

---

## Infraestrutura

| Item | Detalhe |
|---|---|
| Cloud | Microsoft Azure (Azure for Students) |
| VM | `vm-cp2-rm555287` — Ubuntu Server 24.04 LTS |
| Região | Central US |
| IP Público | `172.202.120.139` |
| Tamanho | Standard_D2s_v3 (2 vCPUs, 8 GiB RAM) |

---

## Tecnologias

- **Java 17** + **Spring Boot 3.2**
- **Spring Data JPA** + **MySQL 8.0**
- **Docker** + **Docker Compose**
- **HTML / CSS / JavaScript** (frontend)

---

## Endpoints da API

Base URL: `http://172.202.120.139:8080`

| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/clientes` | Lista todos os clientes |
| GET | `/clientes/{id}` | Busca cliente por ID |
| GET | `/contas` | Lista todas as contas |
| GET | `/contas/{id}` | Busca conta por ID |
| GET | `/transacoes` | Lista todas as transações |
| GET | `/transacoes/{id}` | Busca transação por ID |

### Exemplos

```bash
curl http://172.202.120.139:8080/clientes
curl http://172.202.120.139:8080/contas
curl http://172.202.120.139:8080/transacoes
```

---

## Estrutura do Projeto

```
cp2-dimdim-bank/
├── dimdim-api/
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/main/java/br/com/dimdim/
│       ├── DimdimApiApplication.java
│       ├── controller/
│       │   ├── ClienteController.java
│       │   ├── ContaController.java
│       │   └── TransacaoController.java
│       ├── model/
│       │   ├── Cliente.java
│       │   ├── Conta.java
│       │   └── Transacao.java
│       └── repository/
│           ├── ClienteRepository.java
│           ├── ContaRepository.java
│           └── TransacaoRepository.java
├── frontend/
│   └── index.html
├── mysql/
│   └── init.sql
├── docker-compose.yml
├── setup-vm.sh
└── README.md
```

---

## Banco de Dados

Três tabelas com dados fictícios do banco DimDim:

- **clientes** — 10 clientes cadastrados
- **contas** — 11 contas (Corrente, Poupança, Salário)
- **transacoes** — 20 transações (PIX, TED, DOC, Depósito, Saque)

---

## Como executar localmente

### Pré-requisitos
- Docker e Docker Compose instalados

### Passos

```bash
git clone https://github.com/joaosantis/cp2-dimdim-bank.git
cd cp2-dimdim-bank
docker compose up -d --build
```

Aguarde o MySQL inicializar (~30s) e acesse:
```
http://localhost:8080/clientes
```

---

## Frontend

Abra o arquivo `frontend/index.html` diretamente no browser para visualizar o painel com as tabelas de clientes, contas e transações consumindo a API em tempo real.

---

## Autor

**João Santis** — RM555287
