info = require('netpbm').info
convert = require('netpbm').convert
exec = require('child_process').exec
fs = require('fs')
path = require('path')

module.exports = class Retina
  brunchPlugin: yes
  formats: ['gif', 'jpeg', 'jpg', 'png']
  _resize_binary: 'pnmscale'
  imagePath: 'images'
  retinaRe: /(@2x)\.(?:gif|jpeg|jpg|png)$/

  constructor: (@config) ->
    @retinaRe = @config.plugins.retina.regexp if @config.plugins?.retina?.regexp
    @imagePath = @config.plugins.retina.path if @config.plugins?.retina?.path

    @imagePath = path.join @config.paths.public, @imagePath

    exec "#{@_resize_binary} --version", (error, stdout, stderr) =>
      if error
        console.error "You need to have pnmscale installed. This is usually done with netpbm. Try brew install netpbm if you use homebrew."
    null

  onCompile: (generatedFiles) ->
    baseDirectory = @imagePath.replace(/\/$/, '')
    imageFiles = @fetchFiles baseDirectory
    retinaFiles = (f for f in imageFiles when @retinaRe.test f)

    @processRetina r for r in retinaFiles when @noNormal r

  # Borrowed and modified from imageoptimizer
  fetchFiles: (directory) ->
    recursiveFetch = (directory) ->
      files = []
      prependBase = (filename) ->
        path.join directory, filename
      isDirectory = (filename) ->
        fs.statSync(prependBase filename).isDirectory()
      isFile = (filename) ->
        fs.statSync(prependBase filename).isFile()

      directoryFiles = fs.readdirSync directory
      nextDirectories = directoryFiles.filter isDirectory
      fileFiles = directoryFiles.filter(isFile).map(prependBase)
      files = files.concat(fileFiles)

      for d in nextDirectories
        files = files.concat(recursiveFetch (prependBase d))

      files

    recursiveFetch directory

  processRetinas: (retinas) ->











