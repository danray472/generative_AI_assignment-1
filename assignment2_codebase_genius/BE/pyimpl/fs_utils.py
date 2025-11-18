import os

SKIP_DIRS = {".git", "node_modules", "__pycache__", ".venv", "venv"}

def walk_repo(root: str):
    """Return list of (path, is_dir) relative to root."""
    items = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        rel_dir = os.path.relpath(dirpath, root)
        if rel_dir == ".":
            rel_dir = ""
        items.append((rel_dir, True))
        for f in filenames:
            rel_file = os.path.join(rel_dir, f) if rel_dir else f
            items.append((rel_file, False))
    return items

def read_file_if_exists(root: str, rel_path: str) -> str:
    fp = os.path.join(root, rel_path)
    if os.path.exists(fp) and os.path.isfile(fp):
        with open(fp, "r", encoding="utf-8", errors="ignore") as f:
            return f.read()
    return ""
