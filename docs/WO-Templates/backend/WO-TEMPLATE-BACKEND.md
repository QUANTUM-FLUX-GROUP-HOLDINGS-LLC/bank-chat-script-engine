# Work Order WO-[XXX] - [SERVICE_NAME]

## Meta
| Field | Value |
|-------|-------|
| **WO ID** | `WO-[XXX]-[SERVICE]-[FEATURE]` |
| **Status** | `[DRAFT \| IN_PROGRESS \| REVIEW \| DONE \| BLOCKED]` |
| **Priority** | `[P0 \| P1 \| P2 \| P3]` |
| **Assigned To** | `[@github_username]` |
| **Created** | `YYYY-MM-DD` |
| **Target Sprint** | `Sprint #[N]` |
| **Dependencies** | `WO-[YYY], WO-[ZZZ]` |

## Context & Business Justification
### Problem Statement
> Descripción clara del problema de negocio o necesidad técnica.

### Expected Outcome
> Resultado medible esperado al completar este WO.

### Success Metrics
- [ ] Metric 1: [specific measurement]
- [ ] Metric 2: [specific measurement]
- [ ] Metric 3: [specific measurement]

## Technical Specifications
### Domain Model Changes
```kotlin
// Entity/DTO changes required
@Entity
class NewEntity {
  // ...
}
```

### API Contract Updates
- Endpoint: `POST /api/v1/[resource]`
- Request: `[JSON schema]`
- Response: `[JSON schema]`
- Link to bank-api-contracts: `openapi/v1/[file].yaml`

### Database Schema Changes
- Flyway migration: `flyway/[service]/V[X.X.X]__[description].sql`
- Rollback script: `rollback/[service]/rollback_all.sql`

### External Integrations
- [ ] Third-party API: [name]
- [ ] Vault secrets: `/secret/path/[service]/[key]`
- [ ] Kafka topics: `[topic-name]`

## Implementation Tasks
### Phase 1: Foundation
- [ ] Create entity classes (`/entity/`)
- [ ] Create repository interfaces (`/repository/`)
- [ ] Configure database migrations (`flyway/`)
- [ ] Set up Vault policy access

### Phase 2: Core Logic
- [ ] Implement service layer (`/service/`)
- [ ] Create event publishers (`/event/publisher/`)
- [ ] Create event consumers (`/event/consumer/`)
- [ ] Unit tests (>80% coverage)

### Phase 3: API Layer
- [ ] Create REST controllers (`/controller/`)
- [ ] Update OpenAPI specs (`bank-api-contracts/openapi/v1/`)
- [ ] Integration tests
- [ ] Performance benchmarks

### Phase 4: Security & Compliance
- [ ] Audit logging integration
- [ ] PCI-DSS compliance check (if applicable)
- [ ] OWASP vulnerability scan pass
- [ ] Secret rotation tested

### Phase 5: Documentation & Deployment
- [ ] README.md updated
- [ ] Runbook created (`runbooks/[service]-operations.md`)
- [ ] Helm values configured
- [ ] ArgoCD application created

## Acceptance Criteria
### Functional Requirements
- [ ] [Requirement 1]: Test case `TC-[XXX]-01` passes
- [ ] [Requirement 2]: Test case `TC-[XXX]-02` passes

### Non-Functional Requirements
- [ ] API response time < 200ms at p99
- [ ] Error rate < 0.1%
- [ ] Memory usage < 512MB
- [ ] CPU usage < 30% average

### Security Requirements
- [ ] No secrets in code (gitleaks pass)
- [ ] SQL injection prevention verified
- [ ] Authentication enforced on all endpoints
- [ ] Rate limiting configured

## Test Plan
| Test Type | Tool | Coverage Target | Owner |
|-----------|------|-----------------|-------|
| Unit Tests | JUnit 5 | >80% | @username |
| Integration Tests | TestContainers | 100% endpoints | @username |
| E2E Tests | Playwright | Critical paths | @username |
| Load Tests | k6 | [RPS target] | @username |

## Risks & Mitigations
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Dependency delay | High | Medium | Start with stub/mock |
| Security review bottleneck | Medium | High | Submit early |
| Performance regression | Medium | Medium | Add benchmarks |

## Sign-Off
| Role | Person | Date | Status |
|------|--------|------|--------|
| Tech Lead | | | ⬜ Pending |
| Security Review | | | ⬜ Pending |
| Product Owner | | | ⬜ Pending |
| QA Verification | | | ⬜ Pending |

## Links & References
- [Swagger UI](http://swagger-url)
- [Jira Ticket](https://jira-url)
- [Related WOs](./WO-ARCHIVE/)
- [Architecture Decision Record](../ADRs/ADR-[XXX].md)
