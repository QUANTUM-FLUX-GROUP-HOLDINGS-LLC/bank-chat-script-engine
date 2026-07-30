# Banking Chat Project - Backend Services Backlog

## Priority Order & Dependencies

### Phase 1: Core Foundation (Sprint 1-2)
Estos servicios deben implementarse primero porque todos los demas dependen de ellos.

| WO ID | Servicio | Lenguaje | Prioridad | Dependencias | Descripcion |
|-------|----------|----------|-----------|--------------|-------------|
| WO-001 | bank-chat-service-identity | Kotlin | P0 | None | Auth, JWT, MFA, KYC |
| WO-002 | bank-chat-service-accounting-ledger | Kotlin | P0 | None | Double-entry accounting, event sourcing |
| WO-003 | bank-chat-api-contracts | YAML | P0 | None | OpenAPI specs v1, shared schemas |
| WO-004 | bank-chat-database-migrations | SQL | P0 | WO-001, WO-002 | Flyway migrations for all services |

### Phase 2: Core Banking (Sprint 3-4)
Servicios fundamentales para operaciones bancarias básicas.

| WO ID | Servicio | Lenguaje | Prioridad | Dependencias | Descripcion |
|-------|----------|----------|-----------|--------------|-------------|
| WO-005 | bank-chat-service-payments | Kotlin | P1 | WO-001, WO-002 | Payment transfers, SAGA pattern |
| WO-006 | bank-chat-service-invoicing | Go | P1 | WO-001 | SAT timbrado CFDI, billing |
| WO-007 | bank-chat-service-feature-flags | Go | P1 | WO-001 | Unleash integration, feature toggles |

### Phase 3: Extended Services (Sprint 5-6)
Funcionalidades avanzadas y productos complementarios.

| WO ID | Servicio | Lenguaje | Prioridad | Dependencias | Descripcion |
|-------|----------|----------|-----------|--------------|-------------|
| WO-008 | bank-chat-service-debit-card | Rust | P2 | WO-001, WO-005 | Visa/Mastercard debit processing |
| WO-009 | bank-chat-service-fraud-detection | Python | P2 | WO-002, WO-005 | ML models, real-time anomaly detection |
| WO-010 | bank-chat-service-cashflow-forecast | Python | P2 | WO-002 | LSTM predictions, cashflow analysis |

### Phase 4: Additional Products (Sprint 7-8)
Productos adicionales y optimizaciones finales.

| WO ID | Servicio | Lenguaje | Prioridad | Dependencias | Descripcion |
|-------|----------|----------|-----------|--------------|-------------|
| WO-011 | bank-chat-service-credit-card | Kotlin | P3 | WO-002, WO-009 | Credit scoring, limits |
| WO-012 | bank-chat-service-secured-card | Go | P3 | WO-001, WO-005 | Collateral escrow management |
| WO-013 | bank-chat-service-budget-planner | TypeScript | P3 | WO-002 | Personal finance goals |

### Implementation Timeline

- Sprint 1 (Week 1-2): WO-001 Identity + WO-003 API Contracts
- Sprint 2 (Week 3-4): WO-002 Ledger + WO-004 Database Migrations
- Sprint 3 (Week 5-6): WO-005 Payments + WO-006 Invoicing
- Sprint 4 (Week 7-8): WO-007 Feature Flags + Security hardening
- Sprint 5+ (Week 9+): Remaining services by priority
