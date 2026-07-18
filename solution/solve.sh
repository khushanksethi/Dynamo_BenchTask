#!/usr/bin/env bash
# Oracle reference solution. Reads /app/access.log and writes /app/report.json.
set -euo pipefail

python3 - <<'PY'
import json
import re
from collections import Counter

LOG_PATH = "/app/access.log"
OUT_PATH = "/app/report.json"

# Common Log Format: ... "METHOD /path HTTP/x.y" STATUS SIZE
line_re = re.compile(r'"[A-Z]+\s+(?P<path>\S+)\s+HTTP/\d\.\d"\s+(?P<status>\d{3})\b')

total = 0
errors = 0
paths = Counter()

with open(LOG_PATH, "r", encoding="utf-8") as fh:
    for line in fh:
        m = line_re.search(line)
        if not m:
            continue
        total += 1
        status = int(m.group("status"))
        if status >= 400:
            errors += 1
        paths[m.group("path")] += 1

top_path = paths.most_common(1)[0][0] if paths else ""

report = {
    "total_requests": total,
    "error_count": errors,
    "top_path": top_path,
}

with open(OUT_PATH, "w", encoding="utf-8") as fh:
    json.dump(report, fh)
PY
