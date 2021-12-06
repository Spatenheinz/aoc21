import std/[strutils, parseutils, tables, sequtils]
from std/sequtils import map

proc generate(s: string) : seq[int]  =
  var
    fst: string
    snd: string
    idx: int = parseUntil(s, fst, " ")
  idx = idx + skipUntil(s[idx..^1], {'0'..'9'})
  idx = parseUntil(s[idx..^1], snd, "")
  split(fst & "," & snd, ',').map(parseInt)

func comp(p1: int, p2: int) : int =
  case (p1 - p2):
    of low(int).. -1: 1
    of 0: 0
    else: -1

func overlaps(ct: CountTable) : int =
  for v in values(ct):
    if v > 1:
      result += 1
  return

proc solve () =
  var
    f = splitLines(readFile("input5.txt").strip()).map(generate)
    counts = initCountTable[tuple[x: int,y: int]]()
  for e in f:
     if e[0] == e[2] or e[1] == e[3]:
       for i in min(e[0],e[2]) ..< max(e[0],e[2])+1:
         for j in min(e[1],e[3]) ..< max(e[1], e[3])+1:
           counts.inc((i,j))
  echo(overlaps(counts))
  # part 2
  clear(counts)
  var
    dx, dy, x1, x2, y1, y2 : int
  for e in f:
    (x1, y1, x2, y2) = e
    dx = comp(x1, x2)
    dy = comp(y1, y2)
    counts.inc((x1, y1))
    while x1 != x2 or y1 != y2:
      x1 += dx
      y1 += dy
      counts.inc((x1, y1))
  echo(overlaps(counts))

solve()
