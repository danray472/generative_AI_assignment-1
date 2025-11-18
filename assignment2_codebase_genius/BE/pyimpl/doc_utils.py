import os

def ensure_outputs_dir():
    os.makedirs("outputs", exist_ok=True)

def write_markdown(repo_name: str, content: str) -> str:
    ensure_outputs_dir()
    path = os.path.join("outputs", f"{repo_name}_docs.md")
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    return path
