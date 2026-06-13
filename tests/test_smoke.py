"""Static smoke test for the CRES (fin.html) single-file app.

Validates the shipped artifact without launching a browser: structural
integrity (div balance, no literal </script> in template literals, no
unfilled placeholders, no BOM, unique element IDs) and presence of the
stats-engine entry points. The full end-to-end behavioural checks live in
test_fin_selenium.py, which requires Chrome/Selenium and is run separately.
"""
import os
import re
from collections import Counter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HTML_PATH = os.path.join(ROOT, "fin.html")


def _read_html():
    with open(HTML_PATH, "r", encoding="utf-8") as fh:
        return fh.read()


def test_html_exists_and_nonempty():
    assert os.path.isfile(HTML_PATH), "fin.html artifact missing"
    assert os.path.getsize(HTML_PATH) > 1000


def test_no_bom():
    with open(HTML_PATH, "rb") as fh:
        head = fh.read(3)
    assert head != b"\xef\xbb\xbf", "fin.html starts with a UTF-8 BOM"


def test_div_balance():
    s = _read_html()
    opens = len(re.findall(r"<div[\s>]", s))
    closes = len(re.findall(r"</div>", s))
    assert opens == closes, f"div imbalance: {opens} open vs {closes} close"


def test_no_literal_close_script_in_templates():
    # A literal </script> on a line that also opens a JS template literal would
    # terminate the script block early. Check line-by-line so the legitimate
    # closing </script> tag of the block is not falsely flagged.
    for line in _read_html().splitlines():
        assert not re.search(r"`[^`]*</script>", line), line


def test_no_unfilled_placeholders():
    s = _read_html()
    for token in ("REPLACE_ME", "__PLACEHOLDER__"):
        assert token not in s, f"unfilled placeholder token: {token}"
    assert not re.search(r"\{\{[^}]+\}\}", s), "unfilled {{...}} template token"


def test_unique_element_ids():
    s = _read_html()
    ids = re.findall(r'\sid="([^"]+)"', s)
    dups = {k: v for k, v in Counter(ids).items() if v > 1}
    assert not dups, f"duplicate element IDs: {dups}"


def test_stats_engine_present():
    s = _read_html()
    # Core entry points the engine must expose.
    for marker in ("window.StatsEngine", "estimateTau2", "solveWLS"):
        assert marker in s, f"missing stats-engine marker: {marker}"
