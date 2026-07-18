#!/usr/bin/env bash
# Verifier entrypoint. Runs plain pytest (all deps are baked into the
# environment/Dockerfile, so nothing is installed here) and writes the
# reward + CTRF report to /logs/verifier/.
set -uo pipefail

RESULTS_DIR="/logs/verifier"
mkdir -p "$RESULTS_DIR"

# Run from this script's directory so pytest discovers test_outputs.py.
cd "$(dirname "$0")"

pytest -v --ctrf "$RESULTS_DIR/ctrf.json" test_outputs.py
STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo "1" > "$RESULTS_DIR/reward.txt"
else
  echo "0" > "$RESULTS_DIR/reward.txt"
fi

# Always exit 0: the reward is reported via reward.txt, not the script's status.
exit 0
