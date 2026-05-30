for filename in ['page.tsx', 'globals.css', 'layout.tsx']:
    with open('app/' + filename, 'r', encoding='utf-8') as f:
        text = f.read()
    
    text = text.replace('\\"', '"')
    
    with open('app/' + filename, 'w', encoding='utf-8') as f:
        f.write(text)
