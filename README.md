# Generative AI – Jac & Jaseci Coursework

This repository contains projects for the Generative AI course delivered in collaboration with the Jac / Jaseci team and the Open University of Kenya.

The focus of these assignments is to learn how to build AI‑first applications using the Jac language, multi‑agent patterns, and modern LLM tooling.

---

## Repository structure

- `assignment1_rps/`  
  Rock, Paper, Scissors game implemented in Jac as Assignment 1.  
  Demonstrates basic Jac concepts such as nodes, walkers, abilities, and simple game logic.

- `assignment2_codebase_genius/`  
  Codebase Genius – a multi‑agent code‑documentation system implemented in Jac for Assignment 2.  
  Given a public GitHub repository URL, it analyzes the repo and generates markdown documentation.

---

## Assignment 1 – Rock, Paper, Scissors

Folder: `assignment1_rps/`

This project implements a Rock, Paper, Scissors game using Jac. It is based on the course instructions and the official Jac documentation examples.

Key ideas:

- Command‑line interaction and simple game loop in Jac.
- Separation between core game logic and implementation details.
- Demonstrates how to run Jac code locally and via `jac run` / `jac serve`.

To see details, open the `assignment1_rps/README.md` file and the Jac source files inside that folder.

---

## Assignment 2 – Codebase Genius

Folder: `assignment2_codebase_genius/`

Codebase Genius is a prototype multi‑agent system that:

- Accepts a public GitHub repository URL.
- Clones the repository to a temporary directory.
- Builds a file‑tree representation of the project.
- Performs basic static analysis of Python/Jac files to extract modules, classes, and functions.
- Generates markdown documentation with sections like overview, structure, and API outline.

The backend is implemented in Jac plus a few Python helper modules.

### High‑level architecture

Inside `assignment2_codebase_genius/BE/`:

- `main.jac`  
  Entry point for serving the backend. Exposes an HTTP walker that accepts a GitHub URL and triggers the pipeline.

- `supervisor.jac`  
  Contains the `CodeGenius` supervisor walker.  
  Orchestrates the end‑to‑end workflow:
  1. Calls the Repo Mapper to clone and map the repository.  
  2. Calls the Code Analyzer to build a simple Code Context Graph.  
  3. Calls DocGenie to generate documentation and save it to the `outputs/` directory.

- `repo_mapper.jac`  
  Implements the **Repo Mapper** agent.  
  - Clones the repo (via Python helper).  
  - Builds Jac nodes for repo root, directories, and files.  
  - Skips irrelevant directories such as `.git`, `node_modules`, etc.  
  - Reads `README.md` (if present) and stores a short text summary.

- `code_analyzer.jac`  
  Implements the **Code Analyzer** agent.  
  - Walks through code files (`.py` and `.jac`).  
  - Uses a Python helper to extract a simple outline of functions and classes.  
  - Builds a minimal Code Context Graph with modules, functions, and classes as Jac nodes and edges.

- `docgenie.jac`  
  Implements the **DocGenie** agent.  
  - Reads the repository graph and Code Context Graph.  
  - Produces markdown documentation with:
    - Project overview (from README summary).  
    - High‑level structure (simple mermaid diagram of directories).  
    - Per‑module lists of classes and functions.  
    - Placeholder sections for installation and usage.  
  - Writes the documentation to `assignment2_codebase_genius/outputs/<repo_name>_docs.md`.

- `pyimpl/`  
  Python helper modules used from Jac:
  - `git_utils.py` – clone Git repos and derive repo name from URL.  
  - `fs_utils.py` – walk the repository tree and read files safely.  
  - `parse_utils.py` – simple Python/Jac outline parser (functions/classes), which can later be upgraded to Tree‑sitter.  
  - `doc_utils.py` – write markdown files into the `outputs/` folder.

- `requirements.txt`  
  Python dependencies for the backend (Jac, git utilities, and parsing libraries).

- `README.md`  
  Backend‑specific instructions (setup, running the Jac server, and calling the API).

The folder `assignment2_codebase_genius/outputs/` contains generated documentation files and can optionally be excluded from version control if needed.

---

## Local development setup

These steps assume you have already cloned this repository and are working from the project root.

### 1. Create and activate a virtual environment (Windows example)

