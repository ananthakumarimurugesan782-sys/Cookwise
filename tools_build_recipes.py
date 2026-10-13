"""
Builds assets/data/recipes.json from the two datasets:
  python tools_build_recipes.py dataset.csv Cleaned_Indian_Food_Dataset.csv
- dataset.csv                     (semicolon separated, has ratings + nutrition)
- Cleaned_Indian_Food_Dataset.csv (Indian recipes with a photo URL per recipe)
Duplicates are removed (same dish name, or same photo URL = same dish) and popular dishes come first.
"""
import sys, ast, json, re, pandas as pd

OLD = sys.argv[1] if len(sys.argv) > 1 else 'dataset.csv'
NEW = sys.argv[2] if len(sys.argv) > 2 else 'Cleaned_Indian_Food_Dataset.csv'

GROUPS = {'Indian': ['Indian', 'Indian Inspired'], 'Italian': ['Italian', 'Italian Inspired'], 'Chinese': ['Chinese'],
          'Mexican': ['Mexican', 'Mexican Inspired'], 'Japanese': ['Japanese'], 'Korean': ['Korean']}
LIM = {'Indian': 400, 'Italian': 250, 'Chinese': 250, 'Mexican': 250, 'Japanese': 200, 'Korean': 150}
FAMILIAR = {
 'Indian': ['vegetable biryani', 'chicken biryani', 'biryani', 'butter chicken', 'paneer butter', 'masala dosa', 'dosa', 'idli', 'samosa', 'naan', 'chana masala', 'chole', 'dal tadka', 'dal', 'tikka masala', 'sambar', 'palak paneer', 'aloo gobi', 'vada', 'upma', 'pulao', 'chapati', 'korma', 'puliyodharai', 'pongal', 'rasam', 'appam', 'puttu', 'avial', 'payasam'],
 'Italian': ['margherita', 'pizza', 'lasagna', 'carbonara', 'bolognese', 'spaghetti', 'fettuccine alfredo', 'risotto', 'tiramisu', 'pasta', 'bruschetta', 'gnocchi'],
 'Chinese': ['fried rice', 'kung pao', 'lo mein', 'chow mein', 'noodles', 'sweet and sour', 'dumpling', 'wonton', 'hot and sour', 'egg drop', 'orange chicken', 'manchurian'],
 'Mexican': ['taco', 'burrito', 'enchilada', 'quesadilla', 'guacamole', 'fajita', 'nachos', 'salsa', 'tamale'],
 'Japanese': ['sushi', 'ramen', 'teriyaki', 'tempura', 'miso soup', 'udon', 'tonkatsu', 'katsu', 'okonomiyaki', 'yakitori'],
 'Korean': ['bibimbap', 'kimchi', 'bulgogi', 'japchae', 'tteokbokki', 'korean fried chicken'],
}
def fam_rank(g, name):
    n = name.lower()
    for i, k in enumerate(FAMILIAR.get(g, [])):
        if k in n: return i
    return 999
def norm(n): return re.sub(r' recipe$', '', re.sub(r'[^a-z0-9]+', ' ', str(n).lower()).strip()).strip()
def lit(v):
    try: return ast.literal_eval(v)
    except Exception: return None

def split_steps(steps):
    out = []
    for para in steps:
        sents = [x.strip() for x in re.split(r'(?<=[.!?])\s+(?=[A-Z])', para.strip()) if x.strip()]
        buf = ''
        for t in sents:
            buf = (buf + ' ' + t).strip()
            if len(buf) >= 40: out.append(buf); buf = ''
        if buf:
            if out and len(buf) < 40 and len(sents) > 1: out[-1] += ' ' + buf
            else: out.append(buf)
    return out

def servings(v):
    x = lit(v) if isinstance(v, str) and v.startswith('[') else v
    if isinstance(x, list): x = x[0] if x else None
    try: return int(float(x))
    except Exception: return None

# ---------------- dataset.csv ----------------
df = pd.read_csv(OLD, sep=';', encoding='cp1252', on_bad_lines='skip', engine='python')
items = []
for g, keys in GROUPS.items():
    sub = df[df.Cuisine.apply(lambda v: any(k in (lit(v) or []) for k in keys))]
    sub = sub.assign(_f=sub.Name.apply(lambda x: fam_rank(g, str(x))))
    sub = sub.assign(_fam=(sub._f < 999)).sort_values(['_fam', 'Rating Count'], ascending=[False, False])
    n, seen = 0, set()
    for _, r in sub.iterrows():
        k = norm(r['Name'])
        if k in seen: continue
        ing, steps = lit(r['Ingredients']), lit(r['Instructions'])
        if not ing or not steps: continue
        s = servings(r['Servings'])
        if not s: continue
        seen.add(k)
        nut = lit(r['Nutrition']) or {}
        items.append({'cuisine': g, 'name': str(r['Name']).strip(), 'region': '', 'category': lit(r['Category']) or [],
          'ingredients': [{'n': i.get('ingredient', ''), 'q': i.get('quantity', ''), 'u': i.get('unit', ''), 'm': i.get('misc', '')} for i in ing],
          'steps': split_steps(steps), 'servings': s, 'url': r['URL'], 'image': '',
          'pop': int(r['Rating Count']) if pd.notna(r['Rating Count']) else 0, 'fam': bool(r['_f'] < 999),
          'prep': int(r['Preparation Time']) if pd.notna(r['Preparation Time']) else None,
          'cook': int(r['Cooking Time']) if pd.notna(r['Cooking Time']) else None,
          'rating': float(r['Rating Value']) if pd.notna(r['Rating Value']) else None,
          'nutrition': {k2: v for k2, v in nut.items() if v}, 'methods': lit(r['Cooking Methods']) or []})
        n += 1
        if n >= LIM[g]: break

# ---------------- Cleaned_Indian_Food_Dataset.csv ----------------
SOUTH = {'South Indian Recipes', 'Karnataka', 'Tamil Nadu', 'Kerala Recipes', 'Andhra', 'Chettinad', 'Mangalorean', 'Hyderabadi', 'Udupi', 'Coorg', 'North Karnataka', 'Coastal Karnataka', 'Malabar', 'South Karnataka', 'Kongunadu'}
NORTH = {'North Indian Recipes', 'Punjabi', 'Kashmiri', 'Awadhi', 'Mughlai', 'Rajasthani', 'Himachal', 'Uttar Pradesh', 'Lucknowi', 'Haryana', 'Uttarakhand-North Kumaon'}
OTHER_IN = {'Indian', 'Maharashtrian Recipes', 'Bengali Recipes', 'Gujarati Recipes', 'Goan Recipes', 'Parsi Recipes', 'Konkan', 'Sindhi', 'Assamese', 'Oriya Recipes', 'Bihari', 'North East India Recipes', 'Malvani', 'Nagaland', 'Jharkhand'}
MAP = {**{c: 'Indian' for c in SOUTH | NORTH | OTHER_IN}, 'Italian Recipes': 'Italian', 'Mexican': 'Mexican', 'Chinese': 'Chinese', 'Indo Chinese': 'Chinese',
       'Cantonese': 'Chinese', 'Sichuan': 'Chinese', 'Hunan': 'Chinese', 'Shandong': 'Chinese', 'Japanese': 'Japanese', 'Korean': 'Korean'}
UNITS = {'teaspoon', 'teaspoons', 'tablespoon', 'tablespoons', 'cup', 'cups', 'gram', 'grams', 'kg', 'ml', 'litre', 'litres', 'liter', 'liters', 'inch', 'inches',
         'sprig', 'sprigs', 'pinch', 'clove', 'cloves', 'bunch', 'stick', 'sticks', 'pod', 'pods', 'slice', 'slices', 'piece', 'pieces', 'can', 'cans', 'packet', 'handful',
         'dash', 'medium', 'large', 'small', 'lb', 'pound', 'pounds', 'ounce', 'ounces', 'oz', 'leaves', 'drops', 'sheet', 'sheets'}

def split_top(s):
    out, depth, cur = [], 0, ''
    for ch in s:
        if ch == '(': depth += 1
        elif ch == ')': depth = max(0, depth - 1)
        if ch == ',' and depth == 0: out.append(cur); cur = ''
        else: cur += ch
    out.append(cur)
    return [x.strip() for x in out if x.strip()]

def parse_ing(t):
    t = t.strip(); q = ''
    for pat, fmt in [(r'^(\d+)\s*-\s*(\d+)\s*/\s*(\d+)\s+', lambda m: f'{m[1]} {m[2]}/{m[3]}'), (r'^(\d+)\s+(\d+)\s*/\s*(\d+)\s+', lambda m: f'{m[1]} {m[2]}/{m[3]}'),
                     (r'^(\d+)\s*/\s*(\d+)\s+', lambda m: f'{m[1]}/{m[2]}'), (r'^(\d+(?:\.\d+)?)\s*-\s*(\d+(?:\.\d+)?)\s+', lambda m: m[1]), (r'^(\d+(?:\.\d+)?)\s+', lambda m: m[1])]:
        m = re.match(pat, t)
        if m: q = fmt(m); t = t[m.end():]; break
    u = ''
    if q:
        w = t.split(' ', 1)
        if w and w[0].lower().strip('.') in UNITS: u = w[0].lower().strip('.'); t = w[1] if len(w) > 1 else ''
    name, _, misc = t.partition(' - ')
    return {'n': name.strip(), 'q': q, 'u': u, 'm': misc.strip()}

nd = pd.read_csv(NEW)
nd['Cuisine'] = nd.Cuisine.astype(str).str.replace('\ufeff', '').str.strip()
seen_img, seen_name = set(), {(i['cuisine'], norm(i['name'])) for i in items}
new_items = []
for _, r in nd.iterrows():
    g = MAP.get(r['Cuisine'])
    if not g: continue
    name = re.sub(r'\s+Recipe\b.*$', '', str(r['TranslatedRecipeName']).strip(), flags=re.I).strip() or str(r['TranslatedRecipeName']).strip()
    key = (g, norm(name)); img = str(r['image-url']).strip()
    if key in seen_name or (img in seen_img): continue  # same dish name or same photo = repeated recipe
    ing = [parse_ing(x) for x in split_top(str(r['TranslatedIngredients']))]
    lines = [x.strip() for x in re.split(r'\\n|\n', str(r['TranslatedInstructions'])) if x.strip()]
    steps = split_steps(lines)
    if not ing or not steps: continue
    seen_name.add(key); seen_img.add(img)
    region = 'South Indian' if r['Cuisine'] in SOUTH else 'North Indian' if r['Cuisine'] in NORTH else ('Other' if g == 'Indian' else '')
    t = int(r['TotalTimeInMins']) if pd.notna(r['TotalTimeInMins']) and r['TotalTimeInMins'] > 0 else None
    new_items.append({'cuisine': g, 'name': name, 'region': region, 'category': [], 'ingredients': ing, 'steps': steps, 'servings': 4,
                      'url': str(r['URL']), 'image': img if img.startswith('http') else '', 'pop': 0, 'fam': fam_rank(g, name) < 999,
                      'prep': None, 'cook': t, 'rating': None, 'nutrition': {}, 'methods': []})

# ---------------- merge, order, ids ----------------
order = list(GROUPS)
allr = items + new_items
allr.sort(key=lambda r: (order.index(r['cuisine']), not r['fam'], -r['pop'], fam_rank(r['cuisine'], r['name'])))
for i, r in enumerate(allr): r['id'] = i
json.dump(allr, open('assets/data/recipes.json', 'w', encoding='utf-8'), ensure_ascii=False, separators=(',', ':'))
print(len(items), 'from dataset.csv +', len(new_items), 'from Indian dataset =', len(allr))
