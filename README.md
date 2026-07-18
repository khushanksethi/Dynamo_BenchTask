# Dynamo - Fix the Broken Terminal-Bench Task

Parse an NGINX-style access log into a small JSON summary report.

## What the agent must do

Read `/app/access.log` (common log format) and write a JSON object to
`/app/report.json` with:

- `total_requests` (int) — number of request lines
- `error_count` (int) — requests with HTTP status >= 400
- `top_path` (str) — most frequently requested path

See [instruction.md](instruction.md) for the exact prompt and numbered success
criteria.

## Layout

```
log-report/
├── task.toml                 # TB2 Harbor task config (artifacts, metadata, env)
├── instruction.md            # agent prompt + numbered success criteria
├── environment/
│   ├── Dockerfile            # approved base pinned by @sha256; bakes pytest deps
│   └── access.log            # fixed task input
├── solution/
│   └── solve.sh              # oracle reference solution
└── tests/
    ├── test.sh               # runs plain pytest; writes reward.txt + ctrf.json
    └── test_outputs.py       # asserts actual values, 1 test per criterion
```

## Run

```bash
harbor run -p log-report -a oracle     # reference solution  -> reward 1
harbor run -p log-report --agent nop   # no-op agent          -> reward 0
```

The verifier writes `/logs/verifier/reward.txt` (1/0) and
`/logs/verifier/ctrf.json`.

## Golden values (from the shipped `access.log`)

| field           | value         |
|-----------------|---------------|
| total_requests  | 10            |
| error_count     | 4             |
| top_path        | /index.html   |

If you swap in a different `access.log`, recompute these three constants in
`tests/test_outputs.py`.
