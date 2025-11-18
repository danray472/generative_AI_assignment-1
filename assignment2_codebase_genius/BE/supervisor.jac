import repo_mapper;
import code_analyzer;
import docgenie;

walker CodeGenius {
    has url: str = "";
    has output_path: str = "";


    can entry() {
        report("CodeGenius: starting for " + url);

        // 1. Map repo
        spawn here walker RepoMapper { url = url; } as rm;
        rm.run();
        // After run, there should be a RepoRoot attached to 'here'
        let root = null;
        for n in outgoing(here) {
            if isinstance(n, RepoRoot) {
                root = n;
                break;
            }
        }
        if root == null {
            report("No RepoRoot found, aborting.");
            stop;
        }

        // 2. Analyze code
        spawn root walker CodeAnalyzer { } as ca;
        ca.run();

        // 3. Generate docs
        spawn root walker DocGenie { } as dg;
        dg.run();
        output_path = dg.output_path;

        report("CodeGenius: finished. Docs at " + output_path);
    }
}
