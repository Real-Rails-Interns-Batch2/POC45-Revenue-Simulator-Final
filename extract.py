import re
import ast
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parent
source_path = Path(sys.argv[1]) if len(sys.argv) > 1 else project_root / 'overview.txt'
app_dir = project_root / 'app'
app_dir.mkdir(parents=True, exist_ok=True)

if not source_path.exists():
    raise FileNotFoundError(f'Source file not found: {source_path}')

with source_path.open('r', encoding='utf-8') as f:
    lines = f.readlines()


def extract(line_idx, target):
    try:
        line = lines[line_idx]
        match = re.search(r'"CodeContent":"(.*?)","Description"', line)
        if match:
            raw_val = match.group(1)
            val = ast.literal_eval('"' + raw_val + '"')
            val = ast.literal_eval(val)
            with (app_dir / target).open('w', encoding='utf-8') as out:
                out.write(val)
            print('Success regex for', target)
        else:
            print('No match for', target)
    except Exception as e:
        print('Error extracting', target, e)


extract(10, 'page.tsx')
extract(8, 'globals.css')
extract(7, 'layout.tsx')
