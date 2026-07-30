#!/bin/bash
# trivy-scan.sh - Wrapper for Trivy vulnerability scanning
# Usage: ./trivy-scan.sh [service-dir] [format]
set -euo pipefail

SERVICE_DIR="${1:-.}"
FORMAT="${2:-table}"
OUTPUT_FILE="trivy-results.${FORMAT}"

echo "=========================================
  Trivy Security Scan"
  Target: $SERVICE_DIR"
  Format: $FORMAT"
========================================="

if ! command -v trivy &>/dev/null; then
  echo "ERROR: trivy not installed"
  echo "Install: https://aquasecurity.github.io/trivy/latest/getting-started/installation/"
  exit 1
fi

trivy fs --format "$FORMAT" --output "$OUTPUT_FILE" --severity HIGH,CRITICAL "$SERVICE_DIR"

CRITICAL_COUNT=$(trivy fs --format json "$SERVICE_DIR" | jq "[.Results[].Vulnerabilities[]? | select(.Severity==\"CRITICAL\")] | length" 2>/dev/null || echo 0)

if [ "$CRITICAL_COUNT" -gt 0 ]; then
  echo "FAIL: $CRITICAL_COUNT critical vulnerabilities found"
  echo "Results saved to $OUTPUT_FILE"
  exit 1
else
  echo "PASS: No critical vulnerabilities"
  echo "Results saved to $OUTPUT_FILE"
  exit 0
fi
