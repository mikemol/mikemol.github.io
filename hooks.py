# hooks.py
import subprocess

def on_pre_build(config):
    """
    This function is called by the mkdocs-simple-hooks plugin before the
    MkDocs build process starts.
    """
    print("Running 'doit' to generate assets and index...")
    subprocess.run(["doit"], check=True)
