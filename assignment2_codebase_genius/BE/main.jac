import supervisor;

walker GenerateDocs {
    has str url;
    has str output_path;

    with entry {
        if !exists(request.json.url) {
            report("Missing 'url' in request body.");
            stop;
        }
        url = request.json.url;
        report("Received URL: " + url);

        spawn here walker CodeGenius { url = url; } as cg;
        cg.run();
        output_path = cg.output_path;

        response.status = 200;
        response.body = {
            "message": "Documentation generated.",
            "output_path": output_path
        };
    }
}
