import os
import tempfile
import subprocess
from urllib.parse import urlparse

def clone_repo(url: str) -> str:
    # basic validation
    parsed = urlparse(url)
    if not parsed.scheme.startswith("http"):
        raise ValueError("Invalid URL")
    tmp_dir = tempfile.mkdtemp(prefix="cbg_repo_")
    try:
        subprocess.check_call(["git", "clone", url, tmp_dir])
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Git clone failed: {e}")
    return tmp_dir

def repo_name_from_url(url: str) -> str:
    return os.path.splitext(os.path.basename(urlparse(url).path))[0] or "repo"
