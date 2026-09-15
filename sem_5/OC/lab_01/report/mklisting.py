#!/usr/bin/env python3
"""TEMP.LST (CP866) -> два ASCII-листинга: обработчик INT 08h и подпрограмма sub_1."""
import re

SRC  = '../artefacts/TEMP.LST'
DST1 = 'listing-int08.lst'
DST2 = 'listing-sub1.lst'

raw = open(SRC, 'rb').read().decode('cp866', errors='replace')

rows = []
for line in raw.replace('\r\n', '\n').split('\n'):
    line = ''.join(c if ord(c) < 128 else '-' for c in line)
    parts = [p.strip() for p in line.split('\t') if p.strip()]
    rows.append(parts if parts else None)

code = [r for r in rows if r and re.match(r'^020C:[0-9A-F]{4}', r[0])]
w1 = max(len(r[0]) for r in code) + 2

out = []
for r in rows:
    if r is None:
        out.append('')
    elif re.match(r'^020C:[0-9A-F]{4}', r[0]):
        head, rest = r[0], list(r[1:])
        comment = rest.pop() if rest and rest[-1].startswith(';') else ''
        out.append(f"{head:<{w1}}{' '.join(rest):<30}{comment}".rstrip())
    else:
        out.append(' '.join(r).rstrip())

# граница: первая строка объявления подпрограммы
split = next(i for i, l in enumerate(out) if 'sub_1 proc' in l)

def trim(xs):
    while xs and not xs[0].strip(): xs.pop(0)
    while xs and not xs[-1].strip(): xs.pop()
    return xs

# из первой части выбрасываем служебные хвосты Sourcer (разделители, шапку "Page 2")
part1 = [l for l in out[:split]
         if not l.startswith(';---') and 'SUBROUTINE' not in l and 'Page 2' not in l]
part2 = out[split:]

for path, body in ((DST1, trim(part1)), (DST2, trim(part2))):
    open(path, 'w').write('\n'.join(body) + '\n')
    print(f'{path:22} строк: {len(body):3}  макс. длина: {max(len(l) for l in body)}')
