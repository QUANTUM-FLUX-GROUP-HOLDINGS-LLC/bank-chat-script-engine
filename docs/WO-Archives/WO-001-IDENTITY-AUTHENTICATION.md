# Work Order WO-001 - Identity Service (Authentication)

## Meta
| Field | Value |
|-------|-------|
| **WO ID** | `WO-001-ID-AUTH-LOGIN` |
| **Status** | `IN_PROGRESS` |
| **Priority** | `P0` |
| **Assigned To** | `@ubuntu-77` |
| **Created** | `2026-07-30` |
| **Target Sprint** | `Sprint #1` |
| **Dependencies** | `None` |

## Context & Business Justification
### Problem Statement
> La plataforma necesita un servicio centralizado de identidad para manejar autenticación, autorización y verificación KYC de usuarios personales y empresariales.

### Expected Outcome
> Servicio de identidad desplegado con autenticación JWT, MFA opcional, y verificación KYC integrada, soportando tanto usuarios personales como empresariales.

### Success Metrics
- [ ] Latencia p99 de login < 200ms
- [ ] Disponibilidad del 99.9%
- [ ] Soporte para 10,000 usuarios concurrentes
- [ ] Integración KYC completa con validación documental

## Technical Specifications
### Domain Model Changes
```kotlin
@Entity
class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    val id: String?
=
null,    lateinit var email: String,
lateinit
var
passwordHash:
String,    var tenantContext: TenantContext,
var
status:
UserStatus
=
UserStatus.PENDING_VERIFICATION,    var createdAt: Instant = Instant.now()
}

@Entity
class SessionEntity {
    @Id
    val token: String,
    @ManyToOne
    lateinit var user: UserEntity,
    var expiresAt: Instant,
    var mfaVerified: Boolean = false
}

@Entity
class KycVerificationEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    val id: String?
=
null,    @OneToOne
    lateinit var user: UserEntity,
    lateinit var documentType: DocumentType,
    lateinit var documentNumber: String,
    var verificationStatus: VerificationStatus = VerificationStatus.PENDING,
    var verifiedAt: Instant?
=
null,
    var rejectionReason: String?
=
null
}
```

### API Contract Updates
- Endpoint: `POST /api/v1/auth/register`
- Request: `{ email, password, firstName, lastName, tenantId }`
- Response: `{ userId, requiresKyc, sessionToken }`
- OpenAPI: `bank-api-contracts/openapi/v1/auth-identity-api.yaml`

- Endpoint: `POST /api/v1/auth/login`
- Request: `{ email, password }`
- Response: `{ accessToken, refreshToken, expiresIn }`

- Endpoint: `POST /api/v1/auth/mfa/challenge`
- Request: `{ sessionId }`
- Response: `{ challengeType, challengeId }`

- Endpoint: `POST /api/v1/auth/mfa/verify`
- Request: `{ challengeId, code }`
- Response: `{ accessToken, refreshToken }`

### Database Schema Changes
- Flyway migration: `flyway/identity/V1.0.0__create_users_table.sql`
- Rollback script: `rollback/identity/rollback_all.sql`
- Tables: `users`, `sessions`, `kyc_verifications`, `mfa_devices`

### External Integrations
- [ ] Vault secrets: `/secret/data/identity/jwt-signing-key`
- [ ] Vault secrets: `/secret/data/identity/password-salt`
- [ ] Kafka topics: `user.registered`, `user.verified`, `user.logged-in`

## Implementation Tasks
### Phase 1: Foundation
- [ ] Create UserEntity, SessionEntity, KycVerificationEntity, MfaDeviceEntity
- [ ] Create UserRepository, SessionRepository, KycRepository
- [ ] Configure Flyway migrations (V1.0.0 to V1.0.3)
- [ ] Set up Vault policy access (identity-service.hcl)

### Phase 2: Core Logic
- [ ] Implement AuthService (register, login, refresh, logout)
- [ ] Implement UserService (CRUD, profile, status management)
- [ ] Implement KycService (document upload, verification status)
- [ ] Implement MfaService (TOTP enrollment, challenge, verify)
- [ ] Implement SessionManager (token generation, expiry, revocation)
- [ ] Create event publishers: UserRegisteredEvent, KycVerifiedEvent, UserLoggedInEvent
- [ ] Unit tests for all services (>80% coverage)

### Phase 3: API Layer
- [ ] Create AuthController (register, login, refresh, logout, mfa endpoints)
- [ ] Create UserController (profile, update, deactivate)
- [ ] Create KycController (submit, status, retry)
- [ ] Update OpenAPI specs in bank-api-contracts
- [ ] Integration tests with TestContainers
- [ ] Performance benchmarks (k6 load test: 500 RPS)

### Phase 4: Security & Compliance
- [ ] JWT signing via Vault Transit Engine (no raw keys in code)
- [ ] Password hashing with Argon2id
- [ ] Rate limiting on login endpoint (5 attempts/minute/IP)
- [ ] Audit logging for all auth events
- [ ] Session revocation on password change
- [ ] OWASP Top 10 vulnerability scan pass
- [ ] Gitleaks secret scan pass

### Phase 5: Documentation & Deployment
- [ ] README.md with setup instructions
- [ ] Runbook: identity-operations.md
- [ ] Helm values in bank-k8s-manifests
- [ ] ArgoCD application for dev/staging/prod
- [ ] Grafana dashboard: identity-service-detail.json
- [ ] Prometheus alerts: service-availability + latency-slo

## Acceptance Criteria
### Functional Requirements
- [ ] User registration creates account with PENDING_VERIFICATION status: Test case TC-WO001-01 passes
- [ ] Login with valid credentials returns JWT tokens: Test case TC-WO001-02 passes
- [ ] Login fails gracefully on invalid credentials: Test case TC-WO001-03 passes
- [ ] MFA challenge works for enrolled users: Test case TC-WO001-04 passes
- [ ] KYC submission creates verification record: Test case TC-WO001-05 passes

### Non-Functional Requirements
- [ ] API response time < 200ms at p99 (500 RPS sustained)
- [ ] Error rate < 0.1% under normal load
- [ ] Memory usage < 512MB (steady state)
- [ ] CPU usage < 30% average

### Security Requirements
- [ ] No secrets in code (gitleaks pass)
- [ ] SQL injection prevention verified via OWASP ZAP
- [ ] Authentication enforced on all protected endpoints
- [ ] Rate limiting configured on login endpoint
- [ ] JWT tokens expire after 15 minutes
- [ ] Refresh tokens rotate on use

## Test Plan
| Test Type | Tool | Coverage Target | Owner |
|-----------|------|-----------------|-------|
| Unit Tests | JUnit 5 | >80% | @ubuntu-77 |
| Integration Tests | TestContainers | 100% endpoints | @ubuntu-77 |
| E2E Tests | Playwright | Critical paths | @ubuntu-77 |
| Load Tests | k6 | 500 RPS sustained | @ubuntu-77 |

## Risks & Mitigations
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Vault integration delay | High | Medium | Use mock first, swap later |
| KYC provider complexity | Medium | High | Start with manual review flow |
| Performance bottleneck on login | Medium | Medium | Add caching layer (Redis) |

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
