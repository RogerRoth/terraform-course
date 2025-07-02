# Terraform AWS Multi-Region Course

Este projeto demonstra como criar recursos AWS em múltiplas regiões usando Terraform, incluindo instâncias EC2 em `us-east-1` e `us-west-2`.

## 📋 Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- Conta AWS com permissões apropriadas
- Docker (opcional, para usar container do Terraform)

## 🏗️ Estrutura do Projeto

```
.
├── main.tf                 # Configuração principal e providers
├── servers/
│   ├── ec2.tf             # Recursos EC2 para ambas as regiões
│   ├── variables.tf       # Definição de variáveis
│   └── output.tf          # Outputs dos recursos criados
├── terraform.tfvars.example # Exemplo de configuração de variáveis
└── README.md              # Este arquivo
```

## ⚙️ Configuração

1. **Clone o repositório:**
   ```bash
   git clone <seu-repositorio>
   cd terraform_course
   ```

2. **Configure suas credenciais AWS:**
   ```bash
   aws configure
   # ou use variáveis de ambiente:
   export AWS_ACCESS_KEY_ID="sua_access_key"
   export AWS_SECRET_ACCESS_KEY="sua_secret_key"
   export AWS_DEFAULT_REGION="us-east-1"
   ```

3. **Configure as variáveis (opcional):**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edite terraform.tfvars com seus valores
   ```

## 🚀 Comandos Terraform

### Usando Docker (Recomendado)

```bash
# Inicializar container interativo
docker run -it -v $PWD:/app -w /app --entrypoint "" hashicorp/terraform:light sh
```

### Comandos Principais

```bash
# Inicializar o projeto
terraform init -upgrade

# Visualizar o plano de execução
terraform plan -out=tfplan

# Aplicar as mudanças
terraform apply tfplan

# Destruir os recursos
terraform destroy

# Acessar o console interativo
terraform console
```

## 📦 Recursos Criados

Este projeto cria os seguintes recursos AWS:

- **2 Instâncias EC2**: Uma em `us-east-1` e outra em `us-west-2`
- **AMI Ubuntu 20.04 LTS** (selecionada automaticamente)
- **Instance type**: `t2.micro` (Free Tier eligible)

## 🔧 Personalização

### Variáveis Disponíveis

| Variável | Descrição | Valor Padrão |
|----------|-----------|--------------|
| `image_id` | AMI ID para instância | `ami-020cba7c55df1f615` |
| `instance_type` | Tipo da instância EC2 | `t2.micro` |
| `tags` | Tag para identificação | `terraform-test` |

### Modificando Regiões

Para usar diferentes regiões, edite o arquivo `main.tf` e altere os providers:

```hcl
provider "aws" {
  alias = "region1"
  region = "sua-regiao-1"
}

provider "aws" {
  alias = "region2" 
  region = "sua-regiao-2"
}
```

## 📊 Outputs

Após executar `terraform apply`, você receberá:

- `instance_public_ip`: IP público da instância em us-east-1
- `instance_public_ip_west-2`: IP público da instância em us-west-2

## 🔐 Segurança

⚠️ **IMPORTANTE**: 

- Nunca commite arquivos `*.tfvars` ou `terraform.tfstate`
- Use IAM roles quando possível
- Mantenha suas credenciais AWS seguras
- Revise sempre o plano antes de aplicar

## 🆘 Troubleshooting

### Erro de Autenticação
```bash
# Verifique suas credenciais
aws sts get-caller-identity
```

### Estado Corrompido
```bash
# Re-importar recursos se necessário
terraform import aws_instance.web-east-1 i-1234567890abcdef0
```

### Limpeza de Estado
```bash
# Remover estado local (cuidado!)
rm -rf .terraform terraform.tfstate*
terraform init
```

## 📚 Recursos Adicionais

- [Documentação oficial do Terraform](https://www.terraform.io/docs/)
- [Provider AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Free Tier](https://aws.amazon.com/free/)

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.