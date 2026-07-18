You have an NGINX-style access log at `/app/access.log` in the common log
format, where each line looks like:

    127.0.0.1 - - [10/Oct/2025:13:55:36 -0700] "GET /index.html HTTP/1.1" 200 2326

Write a program that reads that log and produces a small JSON summary report at
the absolute path `/app/report.json`.

The report must be a single JSON object with exactly these three keys:

- `total_requests` (integer): the number of request lines in the log.
- `error_count` (integer): how many requests returned an HTTP status code of
  400 or greater.
- `top_path` (string): the request path (the path portion of the request line,
  e.g. `/index.html`) that appears most often across all requests. The input
  guarantees a single unambiguous most-frequent path.

Success criteria:

1. A file exists at `/app/report.json` and contains a valid JSON object.
2. `total_requests` equals the number of requests in `/app/access.log`.
3. `error_count` equals the number of requests whose HTTP status code is >= 400.
4. `top_path` equals the request path that occurs most frequently in the log.

Only `/app/report.json` is graded; its values must be correct. You may use any
tools already available in the environment; no network access is required.
