fs = require 'fs'

exports.main = main = ->

exports.getPronunciations = ->
  file = __dirname + '/../data/pronunciations'
  throw new Error 'no-pronunciations-file' unless fs.existsSync file
  fs.readFileSync file, {encoding: 'utf8'}
