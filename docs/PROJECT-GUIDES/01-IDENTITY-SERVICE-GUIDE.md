# Guía de Implementación: Identity Service

## Propósito
Esta guía proporciona instrucciones completas para crear un servicio Identity/Authentication desde cero siguiendo las mejores prácticas de Quantum Flux Group Holdings LLC.

## Alcance
- Servicio: Identity (Auth, JWT, MFA, KYC)
- Tecnología: Kotlin + Spring Boot 3.2.5
- Base de datos: PostgreSQL con Flyway
- Arquitectura: DDD básico (Entities, Repositories, Services, Controllers)

## Requisitos Previos
- JDK 17+
- Maven 3.8+ o Gradle 8+
- Docker con PostgreSQL corriendo
- Vault instalado (opcional para dev)

## Estructura Final Esperada
```
bank-chat-service-identity/
├── pom.xml
├── src/main/kotlin/com/quantumflux/identity/
│   ├── config/           # JwtConfig, SecurityConfig, VaultConfig
│   ├── controller/       # AuthController, UserController, KycController
│   ├── dto/              # LoginRequest, RegisterRequest, LoginResponse, etc.
│   ├── entity/           # UserEntity, SessionEntity, KycVerificationEntity, MfaDeviceEntity
│   ├── event/            # UserRegisteredEvent, UserLoggedInEvent, KycVerifiedEvent
│   ├── exception/        # Custom exceptions
│   ├── repository/       # UserRepository, SessionRepository, etc.
│   └── service/          # AuthService, UserService, KycService, etc.
├── src/main/resources/
│   ├── application.yml
│   └── db/migration/
│       ├── V1.0.0__create_users_table.sql
│       ├── V1.0.1__create_sessions_table.sql
│       ├── V1.0.2__create_kyc_verifications_table.sql
│       └── V1.0.3__create_mfa_devices_table.sql
└── docs/
    ├── architecture/
    ├── runbooks/
    └── api/
```

## PASO 1: Crear Repositorio y Estructura

```bash
# Crear directorio del proyecto
cd "$HOME/banking_chat_project"
mkdir bank-chat-service-identity && cd bank-chat-service-identity

# Inicializar Git
git init
git checkout -b main

# Crear estructura de directorios
mkdir -p src/main/kotlin/com/quantumflux/identity/{config,controller,dto,entity,event,exception,repository,service}
mkdir -p src/main/resources/db/migration
mkdir -p src/test/kotlin/com/quantumflux/identity
mkdir -p docs/{architecture,runbooks,api}
```

## PASO 2: Configurar pom.xml

Archivo: `pom.xml`
- Parent: Spring Boot 3.2.5
- Language: Kotlin 1.9.24
- JDK: 17
- Dependencias clave:
  - spring-boot-starter-web
  - spring-boot-starter-data-jpa
  - spring-boot-starter-security
  - flyway-core
  - postgresql
  - kotlin-stdlib, kotlin-reflect

## PASO 3: Configurar application.yml

Archivo: `src/main/resources/application.yml`

```yaml
server:
  port: 8080
  servlet:
    context-path: /api/v1

spring:
  application:
    name: identity-service
  datasource:
    url: jdbc:postgresql://localhost:5432/identity_db
    username: \${DB_USER:identity}
    password: \${DB_PASS:identity_dev}
  flyway:
    enabled: true
    locations: classpath:db/migration

security:
  jwt:
    secret: \${JWT_SECRET:dev-secret-key}
    expiration: 900
  argon2:
    memory: 65536
    iterations: 3
    parallelism: 4

management:
  endpoints:
    web.exposure.include: health,metrics,prometheus
```

## PASO 4: Crear Migraciones Flyway

V1.0.0__create_users_table.sql
V1.0.1__create_sessions_table.sql
V1.0.2__create_kyc_verifications_table.sql
V1.0.3__create_mfa_devices_table.sql

*Ver bank-chat-service-identity/src/main/resources/db/migration/* para ejemplos completos.

## PASO 5: Crear Entidades Kotlin

### UserEntity.kt
- Campos: id, email, passwordHash, tenantContext, status, createdAt, firstName, lastName
- Enum: UserStatus (PENDING_VERIFICATION, ACTIVE, SUSPENDED, DEACTIVATED)

### SessionEntity.kt
- Campos: token, user, expiresAt, mfaVerified, createdAt, revokedAt

### KycVerificationEntity.kt
- Campos: id, user, documentType, documentNumber, verificationStatus, verifiedAt, rejectionReason, submittedAt
- Enums: DocumentType, VerificationStatus

### MfaDeviceEntity.kt
- Campos: id, user, deviceName, secretKey, enabled, enrolledAt, lastUsedAt

⚠️ Nota: Usar `package com.quantumflux.identity.entity`

## PASO 6: Crear Repositorios JPA

### UserRepository.kt
- Extend: JpaRepository<UserEntity, String>
- Methods: findByEmail(), existsByEmail(), findByStatus()

### SessionRepository.kt
- Methods: findByUser_Id(), findExpiredSessions()

### KycVerificationRepository.kt
- Methods: findByUser_Id(), findByVerificationStatus()

### MfaDeviceRepository.kt
- Methods: findByUser_Id(), findByUser_IdAndEnabledTrue()

⚠️ Nota: Usar `package com.quantumflux.identity.repository`

## PASO 7: Implementar Services (Core Logic)

### AuthService.kt
- register(): crear usuario + validar email único + hash password Argon2
- login(): verificar credenciales + generar JWT + crear session
- logout(): revocar token + eliminar session
- refreshToken(): generar nuevo access token

### UserService.kt
- getUserById(), updateUserProfile(), deactivateUser()

### KycService.kt
- submitKycDocument(), getVerificationStatus(), approveKYC(), rejectKYC()

### MfaService.kt
- enrollMfaDevice(), generateChallenge(), verifyChallenge(),

### SessionManager.kt
- createSession(), validateToken(), revokeAllUserSessions()

## PASO 8: Crear Controllers

### AuthController.kt
- POST /auth/register
- POST /auth/login
- POST /auth/logout
- POST /auth/refresh

### UserController.kt
- GET /users/profile
- PUT /users/profile
- DELETE /users/deactivate

### KycController.kt
- POST /kyc/submit
- GET /kyc/status
- POST /kyc/approve
- POST /kyc/reject

## PASO 9: Crear DTOs

Requests: LoginRequest, RegisterRequest, MfaChallengeRequest, KycVerificationRequest
Responses: LoginResponse, RegisterResponse, UserProfileResponse, KycStatusResponse

## PASO 10: Crear Events (Spring Application Events)

### UserRegisteredEvent.kt
### UserLoggedInEvent.kt
### KycVerifiedEvent.kt

## PASO 11: Crear Custom Exceptions

### InvalidCredentialsException.kt
### UserNotFoundException.kt
### KycVerificationFailedException.kt
### SessionExpiredException.kt

## PASO 12: Configuración Spring

### JwtConfig.kt
### SecurityConfig.kt (HttpSecurity, CORS, JWT filter chain)
### VaultConfig.kt

## PASO 13: Principal Application Class

IdentityServiceApplication.kt
- @SpringBootApplication
- Component scanning en com.quantumflux.identity

## INSTRUCCIONES DE GIT COMMIT

```bash
# Stage todos los cambios
git add -A

# Commit siguiendo WO reference
git commit -m "feat(WO-001): Phase 2 Core Logic - services, controllers, DTOs, events

Implementación completa de servicios Identity:
- AuthService, UserService, KycService, MfaService, SessionManager
- Controllers: AuthController, UserController, KycController
- DTOs: Requests y Responses
- Events: UserRegisteredEvent, UserLoggedInEvent, KycVerifiedEvent
- Exceptions custom
- Configuration: JwtConfig, SecurityConfig, VaultConfig

WO-Reference: WO-001-IDENTITY-AUTHENTICATION
Phase: 2/5 - Core Logic Complete"

# Push a main
git push origin main
```

## VERIFICACIÓN FINAL

- [ ] Aplicación arranca sin errores
- [ ] Migraciones Flyway aplicadas correctamente
- [ ] Endpoints respondiendo en /api/v1/auth/*, /users/*, /kyc/*
- [ ] JWT generado y validado correctamente
- [ ] Base de datos PostgreSQL conectada
- [ ] Security scans pasados: ../bank-chat-script-engine/scripts/security/security-scan-all.sh
- [ ] README.md actualizado
- [ ] CODEOWNERS configurado

## REFERENCIAS IMPORTANTES

- WO Template: `docs/WO-Templates/backend/WO-TEMPLATE-BACKEND.md`
- Backlog: `docs/BACKLOG.md`
- Security Scripts: `scripts/security/security-scan-all.sh`
- CI/CD Pipeline: `../bank-chat-ci-cd-pipelines/workflows/kotlin/build-test.yaml`
- WO-001 Example: `docs/WO-Archives/WO-001-IDENTITY-AUTHENTICATION.md`

## BEST PRACTICES A SEGUIR

1. **Naming Conventions**
   - Package: `com.quantumflux.{service-name}`
   - Entity classes: PascalCase, sufijo Entity
   - Repository interfaces: nombre + Repository
   - Service classes: nombre + Service
   - Controllers: nombre + Controller
   - DTOs: nombre + Request/Response

2. **Code Organization**
   - Mantener paquetes consistentes
   - Separar lógica de negocio en Services
   - Controllers solo delegan a Services
   - Validaciones en DTOs con annotations Spring (@NotNull, @Email, etc.)

3. **Git Workflow**
   - Branch naming: `feat/WO-[XXX]-[short-desc]`
   - Commits atómicos con WO-ID
   - Mínimo 1 PR approval requerido
   - Pull request antes del 80%

4. **Security**
   - Nunca hardcoded secrets en código
   - Usar Vault o environment variables
   - Passwords siempre hashed (Argon2id)
   - JWT expiración corta (15 min),
   - HTTPS en producción obligatorio

---

## RESUMEN RÁPIDO DE IMPLEMENTACIÓN

| Fase | Descripción | Archivos Clave | Estado |
|------|-------------|----------------|--------|
| Phase 1 | Foundation | 4 entities, 4 repositories, 4 migrations | ✅ Complete |
| Phase 2 | Core Logic | Services, Controllers, DTOs, Events | ⏳ Pending |
| Phase 3 | API Layer | Integration tests, Swagger docs | ⏳ Pending |
| Phase 4 | Security | Security scans, OWASP audit, Vault integration | ⏳ Pending |
| Phase 5 | Deploy | Helm charts, Kubernetes manifests, docs | ⏳ Pending |

📅 Última actualización: 30 Jul 2026
📝 Basado en implementación real: `bank-chat-service-identity` commit d80afbc

---
🔗 Enlace a implementación real: https://github.com/QUANTUM-FLUX-GROUP-HOLDINGS-LLC/bank-chat-service-identity
