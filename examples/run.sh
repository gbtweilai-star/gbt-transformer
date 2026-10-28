#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_transformer info
PYTHONPATH=src python -m gbt_transformer check --payload '{}'
PYTHONPATH=src python -m gbt_transformer run   --payload '{}'
