import pyimpl.doc_utils as doc_utils;

walker DocGenie {
    has str repo_name;
    has str output_path;

    can entry {
        if !exists(here.name) {
            report("DocGenie must start at RepoRoot node.");
            stop;
        }
        repo_name = here.name;
        let md = build_markdown();
        output_path = doc_utils.write_markdown(repo_name, md);
        report(f"Documentation written to {output_path}");
    }

    can ability build_markdown() -> str {
        let md = "";
        md += "# " + repo_name + " Documentation\n\n";

        // Overview
        md += "## Project Overview\n\n";
        md += here.readme_summary + "\n\n";

        // Simple diagram (Mermaid)
        md += "## High-Level Structure\n\n";
        md += "```
        md += "graph TD\n";
        md += "  Repo[" + repo_name + "]\n";
        for d in neighbors(here, contains) {
            if isinstance(d, DirNode) {
                md += "  Repo --> \"" + d.path + "\"\n";
            }
        }
        md += "```\n\n";

        // Modules and API outline
        md += "## Modules and API\n\n";
        for m in neighbors(here, defines) {
            if !isinstance(m, ModuleNode) {
                continue;
            }
            md += "### " + m.path + "\n\n";

            let funcs = [];
            let classes = [];

            for fn in neighbors(m, contains_func) {
                funcs.append(fn.name);
            }
            for cn in neighbors(m, contains_class) {
                classes.append(cn.name);
            }

            if len(classes) > 0 {
                md += "**Classes**\n\n";
                for c in classes {
                    md += "- " + c + "\n";
                }
                md += "\n";
            }

            if len(funcs) > 0 {
                md += "**Functions**\n\n";
                for f in funcs {
                    md += "- " + f + "\n";
                }
                md += "\n";
            }
        }

        // Installation & Usage placeholders
        md += "## Installation\n\n";
        md += "Describe how to install dependencies (e.g., requirements.txt).\n\n";

        md += "## Usage\n\n";
        md += "Explain how to run the main entry points (e.g., main.py, app.py).\n\n";

        return md;
    }
}
