"""
Adds the Hugging Face dataset "Fathi7ma/kerala-recipes" to assets/data/recipes.json
as South Indian recipes.

    pip install datasets
    python tools_import_kerala.py

The column names of that dataset could not be inspected when this script was written,
so it looks for common names and PRINTS the columns it found. If it reports a missing
column, edit the three lists below (NAME_COLS, ING_COLS, STEP_COLS) and run again.
Run tools_build_recipes.py first (it regenerates recipes.json from dataset.csv).
"""
import ast, json, re
from datasets import load_dataset

NAME_COLS = ['name', 'title', 'recipe_name', 'recipe', 'dish', 'Name', 'Title']
ING_COLS = ['ingredients', 'Ingredients', 'ingredient']
STEP_COLS = ['instructions', 'directions', 'method', 'steps', 'procedure', 'Instructions', 'Method']
SERV_COLS = ['servings', 'serves', 'Servings']
FAMILIAR = ['appam', 'puttu', 'sambar', 'avial', 'fish curry', 'biryani', 'payasam', 'idli', 'dosa', 'parotta', 'porotta',
            'kerala chicken', 'beef fry', 'egg roast', 'thoran', 'rasam', 'upma', 'vada', 'pulao', 'prawn']

ds = load_dataset("Fathi7ma/kerala-recipes")
split = ds['train'] if 'train' in ds else list(ds.values())[0]
print('Columns found:', split.column_names, '| rows:', len(split))

def pick(row, cols):
    for c in cols:
        if c in row and row[c] not in (None, '', []):
            return row[c]
    return None

def as_list(v):
    if v is None: return []
    if isinstance(v, list): return [str(x).strip() for x in v if str(x).strip()]
    t = str(v).strip()
    if t.startswith('['):
        try: return [str(x).strip() for x in ast.literal_eval(t) if str(x).strip()]
        except Exception: pass
    parts = re.split(r'\n|;|\|', t)
    if len(parts) == 1 and t.count(',') >= 2: parts = t.split(',')
    return [p.strip(' -*\u2022') for p in parts if p.strip(' -*\u2022')]

def split_steps(items):
    out = []
    for para in items:
        sents = [x.strip() for x in re.split(r'(?<=[.!?])\s+(?=[A-Z])', para) if x.strip()]
        buf = ''
        for t in sents:
            buf = (buf + ' ' + t).strip()
            if len(buf) >= 40: out.append(buf); buf = ''
        if buf:
            if out and len(buf) < 40 and len(sents) > 1: out[-1] += ' ' + buf
            else: out.append(buf)
    return out

recipes = json.load(open('assets/data/recipes.json', encoding='utf-8'))
have = {(r['cuisine'], re.sub(r'[^a-z0-9]+', ' ', r['name'].lower()).strip()) for r in recipes}
added = 0
for row in split:
    name = pick(row, NAME_COLS); ing = as_list(pick(row, ING_COLS)); steps = split_steps(as_list(pick(row, STEP_COLS)))
    if not name or not ing or not steps:
        continue
    key = ('Indian', re.sub(r'[^a-z0-9]+', ' ', str(name).lower()).strip())
    if key in have: continue
    have.add(key)
    try: serv = int(float(str(pick(row, SERV_COLS)).split()[0]))
    except Exception: serv = 4
    recipes.append({'id': 0, 'name': str(name).strip(), 'cuisine': 'Indian', 'region': 'South Indian', 'category': [],
                    'ingredients': [{'n': i, 'q': '', 'u': '', 'm': ''} for i in ing],  # kept as written; quantities are inside the text
                    'steps': steps, 'servings': serv, 'url': '', 'pop': 0,
                    'fam': any(f in str(name).lower() for f in FAMILIAR),
                    'prep': None, 'cook': None, 'rating': None, 'nutrition': {}, 'methods': []})
    added += 1
if not added:
    raise SystemExit('Nothing imported - check the column names printed above and edit NAME_COLS / ING_COLS / STEP_COLS.')

# keep each cuisine together; popular (familiar) first, then by popularity
order = {c: i for i, c in enumerate(dict.fromkeys(r['cuisine'] for r in recipes))}
recipes.sort(key=lambda r: (order[r['cuisine']], not r.get('fam', False), -r.get('pop', 0)))
for i, r in enumerate(recipes): r['id'] = i
json.dump(recipes, open('assets/data/recipes.json', 'w', encoding='utf-8'), ensure_ascii=False, separators=(',', ':'))
print('Imported', added, 'South Indian recipes. Total now', len(recipes))
