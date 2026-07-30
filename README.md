# bank-chat-script-engine

## Description
> Central scripts and WO system

## Technology Stack
- Language: Bash
- Framework: Bash
- Database: Shell

## Security
- Secrets: HashiCorp Vault
- mTLS for inter-service communication
- OWASP Top 10 compliance mandatory

## CI/CD
- Reusable workflows from bank-chat-ci-cd-pipelines
- Security scans from bank-chat-script-engine/scripts/security/

## Work Orders
- Master WO: bank-chat-script-engine/docs/WO-Archives/
- Naming: feat/WO-[XXX]-[description]
- Template: bank-chat-script-engine/docs/WO-Templates/

## Contributing
1. Branch from main: feat/WO-[XXX]-[description]
2. Run security scans before PR
3. Minimum 1 approval required
4. CODEOWNERS enforced

## Related Repositories
- API Contracts: bank-chat-api-contracts
- CI/CD: bank-chat-ci-cd-pipelines
- Scripts: bank-chat-script-engine
- Migrations: bank-chat-database-migrations
