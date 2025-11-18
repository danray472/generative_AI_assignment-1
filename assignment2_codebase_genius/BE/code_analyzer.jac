import pyimpl.fs_utils as fs_utils;
import pyimpl.parse_utils as parse_utils;

node ModuleNode {
    has str path;
}

node FunctionNode {
    has str name;
    has str path;
}

node ClassNode {
    has str name;
    has str path;
}

edge defines;
edge contains_func;
edge contains_class;

walker CodeAnalyzer {
    has str local_path;

    can entry {
        // assume we are starting from RepoRoot
        if !exists(here.local_path) {
            report("CodeAnalyzer must start at RepoRoot node.");
            stop;
        }
        local_path = here.local_path;
        visit here;
    }

    can visit RepoRoot {
        // for each code file, create ModuleNode, and discover functions/classes
        let items = fs_utils.walk_repo(local_path);
        for i in range(len(items)) {
            let it = items[i];
            let rel_path = it[0];
            let is_dir = it[1];
            if is_dir {
                continue;
            }
            if !(rel_path.endswith(".py") or rel_path.endswith(".jac")) {
                continue;
            }
            spawn here ++> ModuleNode {
                .path = rel_path;
            } as m;
            here ++> defines -> m;

            let code = fs_utils.read_file_if_exists(local_path, rel_path);
            if code == "" {
                continue;
            }
            let outline = parse_utils.simple_python_outline(code);
            for j in range(len(outline)) {
                let item = outline[j];
                if item["type"] == "func" {
                    spawn m ++> FunctionNode {
                        .name = item["name"];
                        .path = rel_path;
                    } as fn;
                    m ++> contains_func -> fn;
                } elif item["type"] == "class" {
                    spawn m ++> ClassNode {
                        .name = item["name"];
                        .path = rel_path;
                    } as cn;
                    m ++> contains_class -> cn;
                }
            }
        }
        report("CodeAnalyzer: basic CCG created.");
    }

    // Simple query ability example
    can ability get_functions_in_module(str module_path) -> list {
        let out = [];
        for m in neighbors(here, defines) {
            if m.path == module_path {
                for fn in neighbors(m, contains_func) {
                    out.append(fn.name);
                }
            }
        }
        return out;
    }
}
