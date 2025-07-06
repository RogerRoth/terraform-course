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

#### 🚀 Comandos Básicos

```bash
# Inicializar o projeto (sempre execute primeiro)
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

#### 🔒 Comandos com State Lock

**Por que adicionamos o DynamoDB?**
O DynamoDB serve como um "trava" para evitar que duas pessoas executem `terraform apply` ao mesmo tempo, o que poderia corromper o estado do Terraform. É uma proteção essencial para trabalho em equipe!

**Quando usar `-lock=false`:**

**Na primeira execução (DynamoDB ainda não existe):**
```bash
# Criar o DynamoDB primeiro
terraform plan -out=tfplan -lock=false
terraform apply tfplan -lock=false
```
> ⚠️ **Por que `-lock=false` aqui?** Porque o DynamoDB ainda não existe, então não pode fazer o lock!

**Depois que o DynamoDB foi criado (uso normal):**
```bash
# Use sempre estes comandos
terraform plan -out=tfplan
terraform apply tfplan
terraform destroy
```
> ✅ **Agora o lock funciona!** O DynamoDB já existe e protege suas execuções.

**Apenas em emergências (lock travado):**
```bash
# Use apenas se o lock estiver travado
terraform plan -out=tfplan -lock=false
terraform apply tfplan -lock=false
terraform destroy -lock=false
```
> 🆘 **Cuidado!** Use só se o lock estiver travado e você tiver certeza que ninguém mais está mexendo no Terraform.

#### 🔧 Comandos de Manipulação de Estado

**terraform state mv - Mover/Renomear recursos:**
```bash
# Renomear um recurso no estado
terraform state mv aws_instance.old_name aws_instance.new_name

# Mover recurso para um módulo
terraform state mv aws_instance.web module.servers.aws_instance.web

# Mover recurso de um módulo para outro
terraform state mv module.old.aws_instance.web module.new.aws_instance.web
```
> 🔄 **Quando usar:** Quando você renomeia recursos no código ou reorganiza módulos sem querer destruir/recriar.

**terraform state list - Listar recursos:**
```bash
# Listar todos os recursos no estado
terraform state list

# Filtrar recursos específicos
terraform state list | grep aws_instance
```
> 📋 **Quando usar:** Para ver todos os recursos gerenciados pelo Terraform.

**terraform state show - Detalhes de um recurso:**
```bash
# Ver detalhes de um recurso específico
terraform state show aws_instance.web-east-1

# Ver em formato JSON
terraform state show -json aws_instance.web-east-1
```
> 🔍 **Quando usar:** Para investigar propriedades específicas de um recurso.

**terraform state rm - Remover do estado:**
```bash
# Remove recurso do estado (sem destruir na AWS)
terraform state rm aws_instance.web-east-1

# Remover múltiplos recursos
terraform state rm aws_instance.web-east-1 aws_instance.web-west-2
```
> ⚠️ **Cuidado:** O recurso continua na AWS, mas Terraform para de gerenciá-lo!

**Exemplo prático - Renomeando uma instância:**
```bash
# 1. Verificar estado atual
terraform state list

# 2. Renomear no estado
terraform state mv aws_instance.old_name aws_instance.new_name

# 3. Atualizar o código .tf com o novo nome

# 4. Verificar que não há mudanças
terraform plan
```

#### 📥 Terraform Import - Importar Recursos Existentes

**Para que serve?**
O `terraform import` permite trazer recursos que já existem na AWS para o controle do Terraform, sem precisar recriá-los.

**terraform import - Importar recursos:**
```bash
# Importar uma instância EC2 existente
terraform import aws_instance.web i-1234567890abcdef0

# Importar um bucket S3
terraform import aws_s3_bucket.my_bucket my-bucket-name

# Importar uma tabela DynamoDB
terraform import aws_dynamodb_table.state_lock terraform-state-lock

# Importar um security group
terraform import aws_security_group.web sg-12345678
```
> 📥 **Quando usar:** Quando você tem recursos na AWS que foram criados manualmente e quer gerenciá-los com Terraform.

**Processo completo de import:**
```bash
# 1. Criar o bloco de recurso vazio no .tf (sem propriedades)
resource "aws_instance" "web" {
  # Deixe vazio inicialmente
}

# 2. Importar o recurso existente
terraform import aws_instance.web i-1234567890abcdef0

# 3. Ver as propriedades atuais
terraform state show aws_instance.web

# 4. Preencher o bloco .tf com as propriedades necessárias
resource "aws_instance" "web" {
  ami           = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
  # ... outras propriedades
}

# 5. Verificar se está sincronizado
terraform plan
```

**Comandos úteis para descobrir IDs:**
```bash
# Listar instâncias EC2
aws ec2 describe-instances --query 'Reservations[].Instances[].{ID:InstanceId,Name:Tags[?Key==`Name`].Value|[0],State:State.Name}'

# Listar buckets S3
aws s3 ls

# Listar tabelas DynamoDB
aws dynamodb list-tables

# Listar security groups
aws ec2 describe-security-groups --query 'SecurityGroups[].{ID:GroupId,Name:GroupName}'
```

**⚠️ Dicas importantes:**
- **Sempre faça backup** do estado antes de importar
- **Comece com o bloco vazio** no .tf
- **Use `terraform state show`** para ver as propriedades
- **Ajuste o .tf** para evitar mudanças desnecessárias
- **Teste com `terraform plan`** antes de aplicar

**Exemplo prático - Importando uma instância EC2:**
```bash
# 1. Descobrir o ID da instância
aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId'

# 2. Criar bloco vazio no servers/ec2.tf
resource "aws_instance" "existing_web" {
  # Será preenchido após import
}

# 3. Importar
terraform import aws_instance.existing_web i-0123456789abcdef0

# 4. Ver propriedades
terraform state show aws_instance.existing_web

# 5. Preencher o bloco com as propriedades essenciais
# 6. Verificar sincronização
terraform plan
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