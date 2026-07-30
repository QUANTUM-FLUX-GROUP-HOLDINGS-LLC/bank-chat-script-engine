#!/bin/bash
# checkov-scan.sh - Wrapper for IaC security scanning
# Usage: ./checkov-scan.sh [target-dir] [framework]
set -euo pipefail

TARGET_DIR="${1:-.}"
FRAMEWORK="${2:-all}"
OUTPUT_FORMAT="${3:-sarif}"
REPORT_FILE="checkov-report.${OUTPUT_FORMAT}"

echo "=========================================
  Checkov Infrastructure Security Scan"
  Target: $TARGET_DIR"
  Framework: $FRAMEWORK"
  Format: $OUTPUT_FORMAT"
========================================="

if ! command -v checkov &>/dev/null; then
  echo "ERROR: checkov not installed"
  echo "Install: pip install checkov"
  exit 1
fi

if [ "$FRAMEWORK" = "terraform" ]; then
  checkov --directory "$TARGET_DIR" --framework terraform --output "$OUTPUT_FORMAT" --compact
elif [ "$FRAMEWORK" = "kubernetes" ]; then
  checkov --directory "$TARGET_DIR" --framework kubernetes --output "$OUTPUT_FORMAT" --compact
else
  checkov --directory "$TARGET_DIR" --output "$OUTPUT_FORMAT" --compact
fi

echo "Report saved to $REPORT_FILE"
exit 0
