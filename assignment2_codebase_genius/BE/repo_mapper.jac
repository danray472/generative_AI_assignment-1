import pyimpl.git_utils as git_utils;
import pyimpl.fs_utils as fs_utils;

node RepoRoot {
    has str url;
    has str local_path;
    has str name;
    has str readme_summary;
}

node DirNode {
    has str path;
}

node FileNode {
    has str path;
    has bool is_code;
}

edge contains;

walker RepoMapper {
    has str url;

    can entry {
        spawn here ++> RepoRoot {
            .url = url;
            .name = git_utils.repo_name_from_url(url);
        } as root;
        root.local_path = git_utils.clone_repo(url);
        report(f"Cloned repo to {root.local_path}");
        visit root;
    }

    can visit RepoRoot {
        // build file tree
        let items = fs_utils.walk_repo(here.local_path);
        for i in range(len(items)) {
            let it = items[i];
            let rel_path = it[0];
            let is_dir = it[1];

            if rel_path == "" && is_dir {
                continue;

            if is_dir {
                spawn here ++> DirNode {
                    .path = rel_path;
                } as d;
                here ++> contains -> d;
            } else {
                spawn here ++> FileNode {
                    .path = rel_path;
                    .is_code = rel_path.endswith(".py") or rel_path.endswith(".jac");
                } as f;
                here ++> contains -> f;
            }
        }

        // read README for summary (for now, no LLM: just truncate)
        let readme_text = "";
        for candidate in ["README.md", "Readme.md", "readme.md"] {
            readme_text = fs_utils.read_file_if_exists(here.local_path, candidate);
            if readme_text != "" {
                break;
            }
        }
        if readme_text != "" {
            if len(readme_text) > 1000 {
                here.readme_summary = readme_text[0:1000] + "...";
            } else {
                here.readme_summary = readme_text;
            }
        } else {
            here.readme_summary = "No README found.";
        }

        report("Repo mapping complete.");
    }
}
