import sys
import re
import ast
import json
from pathlib import Path

project_root = Path(__file__).resolve().parent
source_path = Path(sys.argv[1]) if len(sys.argv) > 1 else project_root / 'overview.txt'
app_dir = project_root / 'app'
app_dir.mkdir(parents=True, exist_ok=True)

if not source_path.exists():
    raise FileNotFoundError(f'Source file not found: {source_path}')

text = source_path.read_text(encoding='utf-8')

def restore(search_str, end_str, target):
    idx1 = text.find(search_str)
    if idx1 != -1:
        idx2 = text.find(end_str, idx1)
        if idx2 != -1:
            raw_val = text[idx1 + len('"CodeContent":"'):idx2]
            try:
                # Need to use literal_eval properly
                val = ast.literal_eval('"' + raw_val.replace('"', '\\"') + '"')
                # Actually, the raw string is a JSON encoded string. Let's try json.loads instead of ast.
                import json
                try:
                    val = json.loads('"' + raw_val + '"')
                    val = json.loads(val)
                except:
                    # fallback
                    val = raw_val.replace('\\n', '\n').replace('\\"', '"').replace('\\\\', '\\')
                
                with (app_dir / target).open('w', encoding='utf-8') as out:
                    out.write(val)
                print('Restored', target)
            except Exception as e:
                print('Error evaluating', target, e)
                # Fallback simple replacement
                val = raw_val.replace('\\n', '\n').replace('\\"', '"').replace('\\\\', '\\')
                with (app_dir / target).open('w', encoding='utf-8') as out:
                    out.write(val)
                print('Restored (fallback)', target)
        else:
            print('Could not find end for', target)
    else:
        print('Could not find start for', target)

restore('"CodeContent":"\\"use client\\";\\n\\nimport { useState', '","Description":"\\"Main dashboard page', 'page.tsx')
restore('"CodeContent":"@import url(\\"https://fonts.googleapis.com', '","Description":"\\"Initialized global styles', 'globals.css')
restore('"CodeContent":"import \\"./globals.css\\";\\nimport type', '","Description":"\\"Created root layout', 'layout.tsx')
