#!/bin/bash
# gitleaks-scan.sh - Wrapper for secret detection
# Usage: ./gitleaks-scan.sh [target-path] [report-format]
set -euo pipefail

TARGET_PATH="${1:-.}"
REPORT_FORMAT="${2:-json}"
REPORT_FILE="gitleaks-report.${REPORT_FORMAT}"

echo "=========================================
  Gitleaks Secret Scan"
  Target: $TARGET_PATH"
  Format: $REPORT_FORMAT"
========================================="

if ! command -v gitleaks &>/dev/null; then
  echo "ERROR: gitleaks not installed"
  echo "Install: https://github.com/gitleaks/gitleaks/releases"
  exit 1
fi

if [ "$REPORT_FORMAT" = "json" ]; then
  gitleaks detect --source "$TARGET_PATH" --report-format json --report-path "$REPORT_FILE" --no-git 2>/dev/null || true
else
  gitleaks detect --source "$TARGET_PATH" --report-format sarif --report-path "$REPORT_FILE" --no-git 2>/dev/null || true
fi

LEAK_COUNT=$(gitleaks detect --source "$TARGET_PATH" --report-format json --no-git 2>&1 | grep -c "\"RuleID\":" 2>/dev/null || echo 0)

if [ "$LEAK_COUNT" -gt 0 ]; then
  echo "FAIL: $LEAK_COUNT potential secrets found"
  echo "Report saved to $REPORT_FILE"
  exit 1
else
  echo "PASS: No secrets detected"
  echo "Report saved to $REPORT_FILE"
  exit 0
fi
