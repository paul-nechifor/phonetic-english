{exec} = require 'child_process'
fs = require 'fs'

data = __dirname + '/../data'

mobySymbols = """
  &    (@)  A    eI   @    -    b    tS
  d    E    i    f    g    h    hw   I
  aI   dZ   k    l    m    N    n    Oi
  AU   O    oU   u    U    p    r    S
  s    T    D    t    @r   v    w    j
  Z    z
""".split /\s+/

ordMap = {}
ordMap[s] = String.fromCharCode 65 + i for s, i in mobySymbols
ordMap['_'] = '-' # Dashes are represended in moby as '_'. Map back to '-'.

# Transforms the codes to use single ordered characters for simpler processing.
main = (cb) ->
  console.log 'Transforming pronunciations...'
  fs.readFile data + '/mpron10/mpron.txt', {encoding: 'utf8'}, (err, data) ->
    return cb err if err
    words = {}
    for line in data.split '\n'
      addWord words, line
    writeWords words, cb

addWord = (words, line) ->
  line = line.trim()
  return if line.length is 0

  line = line.replace '[@]', '(@)'
  split = line.split ' '
  return if split.length > 2 # This shouldn't happend!
  [word, pron] = split

  # Ignore pronunciations with more than one word like 'absentee_voter'.
  return unless word.indexOf('_') is -1

  pron = pron
  .replace /('|,)/g, '/' # Remove stress.
  .replace /_/g, '/_/' # Pad dashes so that they end up as symbols.
  .split /\/+/ # Split into symbols.
  .filter (s) -> s.length > 0 # Remove empty symbols

  encoding = ''

  for symbol in pron
    if ordMap[symbol]
      encoding += ordMap[symbol]
      continue
    # Add as if every character is a symbol.
    for char in symbol
      encoding += ordMap[char] if ordMap[char]

  words[word] = encoding

writeWords = (words, cb) ->
  sorted = []
  sorted.push [word, encoding] for word, encoding of words
  sorted = sorted
  .sort()
  .map (l) -> l.join '\t'
  .join '\n'
  fs.writeFile data + '/pronunciations', sorted, cb

main (err) -> throw err if err
