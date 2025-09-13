# dodo.py
import pathlib
import re
from doit.tools import run_once

# Define the base directory for all documentation
DOCS_DIR = pathlib.Path("docs")

def task_assets():
    """
    Regenerate SVG and PNG assets from their source .dot files.
    This task will only run if a .dot file has been modified.
    """
    dot_files = list(DOCS_DIR.glob("**/*.dot"))
    for dot_file in dot_files:
        svg_file = dot_file.with_suffix(".svg")
        png_file = dot_file.with_suffix(".png")
        
        yield {
            "name": str(dot_file.relative_to(DOCS_DIR)),
            "file_dep": [dot_file],
            "targets": [svg_file, png_file],
            "actions": [
                f"dot -Tsvg -o {svg_file} {dot_file}",
                f"dot -Tpng -o {png_file} {dot_file}",
                # Add optimization commands for PNGs
                (
                    f"pngquant --force --ext .png --quality 95-100 {png_file} && "
                    f"pngcrush -ow -brute -l 9 -q {png_file}"
                ),
            ],
            "clean": True,
        }

def task_index():
    """
    Auto-generate the main blog index page with a reverse-chronological
    list of all posts.
    """
    blog_dir = DOCS_DIR / "blog"
    index_page = blog_dir / "index.md"
    
    # Gather all post files, excluding the main index itself
    post_files = [
        p for p in blog_dir.glob("**/index.md") if p.parent != blog_dir
    ]

    def generate_index():
        """The actual Python function that builds the index content."""
        posts = []
        for post_file in post_files:
            # Extract date and slug from the path: blog/YYYY/MM/DD/slug/index.md
            match = re.search(r"(\d{4})/(\d{2})/(\d{2})/([^/]+)", str(post_file))
            if match:
                year, month, day, slug = match.groups()
                # Create a title from the slug
                title = slug.replace("-", " ").replace("_", " ").title()
                # Define the relative path for the link
                relative_path = post_file.relative_to(blog_dir)
                
                posts.append({
                    "year": year,
                    "date": f"{year}-{month}-{day}",
                    "title": title,
                    "path": str(relative_path).replace("index.md", ""),
                })

        # Sort posts by date in descending order
        posts.sort(key=lambda p: p["date"], reverse=True)

        # Generate the Markdown content
        content = ["# Blog\n\n", "A collection of posts...\n\n"]
        current_year = None
        for post in posts:
            if post["year"] != current_year:
                current_year = post["year"]
                content.append(f"### {current_year}\n")
            content.append(f"* [{post['title']}]({post['path']})\n")
        
        index_page.write_text("".join(content))

    return {
        "file_dep": post_files,
        "targets": [index_page],
        "actions": [generate_index],
        "clean": True,
    }
