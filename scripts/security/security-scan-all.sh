#!/bin/bash
# security-scan-all.sh - Run all security scans sequentially
# Usage: ./security-scan-all.sh [target-dir]
set -euo pipefail

TARGET_DIR="${1:-.}"

echo "==========================================
  MASTER SECURITY SCAN ORCHESTRATOR"
  Target: $TARGET_DIR"
=========================================="""

FAILED_SCANS=0

echo ""
echo "[1/3] Running Trivy Vulnerability Scan..."
if ./scripts/security/trivy-scan.sh "$TARGET_DIR"; then
  echo "✓ Trivy PASSED"
else
  FAILED_SCANS=$((FAILED_SCANS + 1))
fi

echo ""
echo "[2/3] Running Gitleaks Secret Scan..."
if ./scripts/security/gitleaks-scan.sh "$TARGET_DIR"; then
  echo "✓ Gitleaks PASSED"
else
  FAILED_SCANS=$((FAILED_SCANS + 1))
fi

echo ""
echo "[3/3] Running Checkov IaC Scan..."
if ./scripts/security/checkov-scan.sh "$TARGET_DIR" terraform; then
  echo "✓ Checkov PASSED"
else
  FAILED_SCANS=$((FAILED_SCANS + 1))
fi

echo ""
echo "==========================================">
  SECURITY SCAN SUMMARY"
==========================================">

if [ "$FAILED_SCANS" -eq 0 ]; then
  echo "✓ ALL SECURITY SCANS PASSED"
  exit 0
else
  echo "✗ $FAILED_SCANS security scan(s) FAILED"
  exit 1
fi
