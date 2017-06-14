{Translator} = require '../src'
require('chai').should()

correct = [
  'Hello world!'
  'Heloh warld!'
  'Turn the ignition on, will you?'
  'Tarn thah ignishahn an, wil yoo?'
]

describe 'Translator', ->
  t = new Translator
  describe '#translate', ->
    for text, i in correct by 2
      do (text, i) ->
        it "should translate '#{text}'", ->
          t.translate(text).should.equal correct[i + 1]
