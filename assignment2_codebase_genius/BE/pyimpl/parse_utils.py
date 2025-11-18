def simple_python_outline(code: str):
    """
    Very naive fallback parser:
    Returns list of dicts: {"type": "func"/"class", "name": str}
    Replace with Tree-sitter to meet full spec.
    """
    outline = []
    for line in code.splitlines():
        line = line.strip()
        if line.startswith("def "):
            name = line.split("(")[0][4:].strip()
            outline.append({"type": "func", "name": name})
        elif line.startswith("class "):
            name = line.split(":")[0][6:].strip()
            outline.append({"type": "class", "name": name})
    return outline
