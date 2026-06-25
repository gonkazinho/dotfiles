import platform
import os
import json
from pathlib import Path

overwrite = {}
try:
    with open("overwrite.json", "r") as file:
        json = json.load(file)

        os_name = platform.system().lower()
        if os_name in json:
            overwrite = json[os_name]
except FileNotFoundError:
    print("overwrite.json not found")


dot_config = Path("dot_config").absolute()
for x in os.listdir(dot_config):
    target_path = Path.home() / ".config" / x
    if x in overwrite:
        target_path = Path(os.path.expandvars(overwrite[x]))
    try:
        os.symlink(dot_config / x, target_path)
    except FileExistsError:
        print(f"'{target_path}' already exists.")
