def _hytale_repo_impl(ctx):
    workspace_root = ctx.path(Label("@//:MODULE.bazel")).dirname
    local_jar = workspace_root.get_child(".local-assets").get_child("HytaleServer.jar")

    if local_jar.exists:
        print("DEBUG: Found local Hytale JAR at {}. Using it.".format(local_jar))
        ctx.symlink(local_jar, "hytale.jar")
    else:
        print("DEBUG: Local JAR not found at {}. Downloading...".format(local_jar))
        ctx.download(
            url = "https://artifacts.yakovliam.com/HytaleServer.jar",
            output = "hytale.jar",
            # sha256 = "..." 
        )

    ctx.file("BUILD", """
java_import(
    name = "server",
    jars = ["hytale.jar"],
    visibility = ["//visibility:public"],
)
""")

hytale_repository = repository_rule(
    implementation = _hytale_repo_impl,
)

def _hytale_extension_impl(ctx):
    hytale_repository(name = "remote_hytale_server")

hytale_ext = module_extension(
    implementation = _hytale_extension_impl,
)