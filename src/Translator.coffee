module.exports = class Translator
  constructor: (data, spelling=Translator.spelling.default) ->
    @map = map = toMap data, spelling
    @translateFunc = do (map) ->
      (word) ->
        # Return word if exists as is in the map.
        m = map[word]
        return m if m

        # Find lower case word in the map.
        lower = word.toLowerCase()
        m = map[lower]

        # Return original word if not found.
        return word unless m

        # If single letter, return in upper case.
        return m.toUpperCase() if word.length is 1

        c0Upper = word.charCodeAt(0) < 97
        cnUpper = word.charCodeAt(word.length - 1) < 97

        # If the entire(-ish) word is upper case make the spelling upper case.
        return m.toUpperCase() if c0Upper and cnUpper

        # Return as title case.
        m[0].toUpperCase() + m.substr 1

  @spelling =
    default: """
      a    a    a    ey   ah   uh   b    ch
      d    e    ee   f    g    h    w    i
      ahy  j    k    l    m    ng   n    oi
      ou   o    oh   oo   oo   p    r    sh
      s    th   th   t    uhr  v    w    y
      zh   z
    """.split /\s+/
    ipa: """
      æ    ɛ    ɑː   e    ʌ    ə    b    tʃ
      d    ɛ    iː   f    g    h    hw   ɪ
      aɪ   dʒ   k    l    m    ŋ    n    ɔɪ
      aʊ   ɔː   oʊ   uː   ʊ    p    r    ʃ
      s    θ    ð    t    ɜr   v    w    j
      ʒ    z
    """.split /\s+/

  translate: (text) ->
    text.replace /[a-zA-Z']+/g, @translateFunc

# Map English words to words with the new spelling.
toMap = (data, spelling) ->
  map = {}
  for line in data.split '\n'
    parts = line.split '\t'
    word = parts[0]
    newWord = []
    for c in parts[1]
      newWord.push spelling[c.charCodeAt(0) - 65]
    newWord = newWord.join ''
    map[word] = newWord
    # Add lower case word if it doesn't push another out.
    word = word.toLowerCase()
    map[word] = newWord.toLowerCase() unless map[word]
  map
