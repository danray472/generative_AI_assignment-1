# Codebase Genius – Backend (Assignment 2)

This folder contains the Jac backend for **Codebase Genius**, Assignment 2 of the Generative AI / Jac & Jaseci course.

Given a public GitHub repository URL, the backend:

- Clones the repository to a temporary directory.
- Maps the file and folder structure into a Jac graph.
- Performs basic static analysis of Python/Jac files (modules, classes, functions).
- Generates markdown documentation and saves it under `../outputs/`.

---

## Folder structure

- `main.jac`  
  Backend entry point. Defines an HTTP walker that accepts a GitHub URL and triggers the full documentation pipeline.

- `supervisor.jac`  
  Contains the **CodeGenius** supervisor walker. Orchestrates:
  1. Repo mapping  
  2. Code analysis  
  3. Documentation generation

- `repo_mapper.jac`  
  Implements the **Repo Mapper** agent:
  - Clones the target repository (via Python helpers in `pyimpl/`).
  - Builds nodes for `RepoRoot`, `DirNode`, and `FileNode`.
  - Ignores irrelevant directories such as `.git`, `node_modules`, `__pycache__`, etc.
  - Reads and stores a short summary of `README.md` if present.

- `code_analyzer.jac`  
  Implements the **Code Analyzer** agent:
  - Scans code files (`.py` and `.jac`).
  - Uses a Python helper to extract a simple outline of functions and classes.
  - Builds a minimal **Code Context Graph (CCG)** with modules, functions, and classes.

- `docgenie.jac`  
  Implements the **DocGenie** agent:
  - Uses the repo map and CCG to construct documentation.
  - Generates markdown including:
    - Project overview
    - High‑level structure diagram (mermaid)
    - Per‑module lists of classes and functions
    - Basic Installation and Usage sections
  - Writes a file like `../outputs/<repo_name>_docs.md`.

- `pyimpl/`  
  Python helper modules called from Jac:
  - `git_utils.py` – clone repositories and compute repo name from URL.
  - `fs_utils.py` – walk the filesystem and read files safely.
  - `parse_utils.py` – simple parser that extracts function/class names (can later be replaced with Tree‑sitter).
  - `doc_utils.py` – writes markdown into the `outputs` folder.

- `requirements.txt`  
  Python dependencies for the backend (Jac and helper libraries).

---


