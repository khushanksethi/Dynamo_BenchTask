import json
import os

import pytest

REPORT_PATH = "/app/report.json"

# Expected values are the golden answer computed from the fixed /app/access.log
# input that ships with this task (10 request lines).
EXPECTED_TOTAL_REQUESTS = 10
EXPECTED_ERROR_COUNT = 4          # status >= 400: 404, 500, 403, 404
EXPECTED_TOP_PATH = "/index.html"  # appears 5 times (most frequent)


@pytest.fixture(scope="module")
def report():
    """Load the produced report once for all value assertions."""
    assert os.path.exists(REPORT_PATH), f"{REPORT_PATH} was not created"
    with open(REPORT_PATH, "r", encoding="utf-8") as fh:
        return json.load(fh)


def test_report_is_valid_json_object():
    """Criterion 1: /app/report.json exists and is a valid JSON object."""
    assert os.path.exists(REPORT_PATH), f"{REPORT_PATH} was not created"
    with open(REPORT_PATH, "r", encoding="utf-8") as fh:
        data = json.load(fh)  # raises/fails if not valid JSON
    assert isinstance(data, dict), "report.json must be a JSON object"


def test_total_requests(report):
    """Criterion 2: total_requests equals the number of requests in the log."""
    assert report["total_requests"] == EXPECTED_TOTAL_REQUESTS


def test_error_count(report):
    """Criterion 3: error_count equals the number of requests with status >= 400."""
    assert report["error_count"] == EXPECTED_ERROR_COUNT


def test_top_path(report):
    """Criterion 4: top_path equals the most frequently requested path."""
    assert report["top_path"] == EXPECTED_TOP_PATH
