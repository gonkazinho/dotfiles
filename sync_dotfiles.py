import json
import os
import platform
from pathlib import Path

overwrite = {}
try:
    with open("overwrite.json", "r") as file:
        data = json.load(file)
        os_name = platform.system().lower()
        if os_name in data:
            overwrite = data[os_name]
except FileNotFoundError:
    print("overwrite.json not found")


def link_file(source: Path, target: Path):
    target.parent.mkdir(parents=True, exist_ok=True)
    try:
        os.symlink(source, target)
    except FileExistsError:
        print(f"'{target}' already exists.")


dot_config = Path("dot_config").absolute()

for entry in os.listdir(dot_config):
    source = dot_config / entry

    if entry in overwrite:
        base_target = Path(os.path.expandvars(overwrite[entry]))
    else:
        base_target = Path.home() / ".config" / entry

    if source.is_dir():
        for root, _dirs, files in os.walk(source):
            root_path = Path(root)
            relative = root_path.relative_to(source)
            for name in files:
                link_file(root_path / name, base_target / relative / name)
    else:
        link_file(source, base_target)
