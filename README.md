# 3-Tier AWS Architecture — Terraform Modules

Deploys a high-availability 3-tier web application on AWS using reusable Terraform modules.

```
Internet
    │
[External ALB]        ← public subnets, port 80
    │
[Web ASG]             ← private subnets, Apache on port 80
    │
[Internal ALB]        ← private subnets, port 80 → 8080
    │
[App ASG]             ← private subnets, Python HTTP server on port 8080
    │
[RDS MySQL Multi-AZ]  ← private subnets, port 3306
```

All compute runs in private subnets. Only the external ALB is internet-facing. Security groups are chained by reference so each tier only accepts traffic from the tier directly above it.

---

## Project Structure

```
modules/
  vpc/              — VPC, subnets, IGW, NAT gateway, route tables
  security-groups/  — Five chained security groups (one per tier boundary)
  alb/              — Reusable ALB + target group + listener (used twice)
  asg/              — Reusable launch template + ASG (used twice)
  rds/              — RDS MySQL, DB subnet group, Secrets Manager password

environments/
  dev/
    backend.tf          — S3 remote state with DynamoDB locking
    provider.tf         — AWS + random provider requirements
    main.tf             — Module wiring
    variables.tf        — All input declarations
    terraform.tfvars    — Dev-specific values
    outputs.tf          — VPC IDs, ALB DNS names, ASG names, RDS endpoint
    templates/
      web_user_data.sh  — Apache install script for web servers
      app_user_data.sh  — Python HTTP server script for app servers
```

---

## Prerequisites

The S3 state bucket and DynamoDB lock table must exist before running `terraform init`. Create them once:

```bash
# State bucket
aws s3api create-bucket \
  --bucket 3tier-project-homelab-backend-bucket006 \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket 3tier-project-homelab-backend-bucket006 \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket 3tier-project-homelab-backend-bucket006 \
  --server-side-encryption-configuration \
    '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

# DynamoDB lock table (LockID is the required hash key name)
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

---

## Deployment

```bash
cd environments/dev

export AWS_ACCESS_KEY_ID=<your-key>
export AWS_SECRET_ACCESS_KEY=<your-secret>

terraform init
terraform validate
terraform plan
terraform apply
```

After apply, the public endpoint is printed as `external_alb_dns_name`.

To tear down:

```bash
terraform destroy
```

---

## Module Reference

| Module | Purpose |
|---|---|
| `vpc` | VPC, 8 subnets across 2 AZs, IGW, NAT gateway, public and private route tables |
| `security-groups` | Five security groups chained by SG reference: `external_alb → web → internal_alb → app → db` |
| `alb` | Generic ALB + target group + HTTP listener. Used for both the external (internet-facing) and internal ALBs by flipping `internal = true/false` |
| `asg` | Generic launch template + Auto Scaling Group. Accepts a raw shell script via `user_data_script` and base64-encodes it internally |
| `rds` | MySQL RDS instance with a randomly generated password stored in Secrets Manager. Multi-AZ controlled by variable |

---

## Extending to Staging / Production

Copy the `environments/dev/` directory:

```bash
cp -r environments/dev environments/staging
```

Update `backend.tf` key, e.g. `key = "staging/terraform.tfstate"`, and set environment-specific values in `terraform.tfvars`:

```hcl
env    = "staging"
db_multi_az            = true
db_skip_final_snapshot = false
db_deletion_protection = true
web_instance_type      = "t3.small"
app_instance_type      = "t3.small"
```

Each environment gets its own state file and its own isolated set of AWS resources — no shared state between environments.
