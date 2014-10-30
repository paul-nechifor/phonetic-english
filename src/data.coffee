{exec} = require 'child_process'

data = __dirname + '/../data'

main = (cb) ->
  downloadFile (err) ->
    return cb err if err

downloadFile = (cb) ->
  # You can't pipe wget and unzip because the ZIP format was invented by people
  # who think that having the file list at the end of the archive is a good
  # idea.
  zip = data + '/mpron.zip'
  console.log 'Downloading the pronunciations...'
  exec """
    mkdir -p '#{data}' 2>/dev/null
    wget 'http://www.gutenberg.org/dirs/etext02/mpron10.zip' -qO '#{zip}'
    unzip -p '#{zip}' mpron.txt > '#{data}'/mpron.txt
    rm '#{zip}'
  """, cb

main (err) -> throw err if err
