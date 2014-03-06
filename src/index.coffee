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
  retinaRe: /(@2[xX])\.(?:gif|jpeg|jpg|png)$/
  minWidth: 0
  minHeight: 0

  constructor: (@config) ->
    @minWidth = @config.plugins.retina.minWidth if @config.plugins?.retina?.minWidth
    @minHeight = @config.plugins.retina.minHeight if @config.plugins?.retina?.minHeight
    @retinaRe = @config.plugins.retina.regexp if @config.plugins?.retina?.regexp
    @imagePath = @config.plugins.retina.path if @config.plugins?.retina?.path
    @assetsPath = @config.paths.public
    @assetsPath = @config.plugins.retina.assetsPath if @config.plugins?.retina?.assetsPath

    @imagePath = path.join @assetsPath, @imagePath

    exec "#{@_resize_binary} --version", (error, stdout, stderr) =>
      if error
        console.error "You need to have pnmscale installed. This is usually done with netpbm. Try brew install netpbm if you use homebrew."
    null

  onCompile: (generatedFiles) ->
    baseDirectory = @imagePath.replace(/\/$/, '')
    imageFiles = @fetchFiles baseDirectory
    retinaFilepaths = (f for f in imageFiles when @retinaRe.test f)

    for retinaPath in retinaFilepaths
      normalPath = @getNormalFilepath retinaPath
      @createNormal(normalPath, retinaPath) unless @normalExists normalPath

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

  createNormal: (normalPath, retinaPath) ->
    info retinaPath, (error, result) =>
      if error
        console.error "retina-brunch couldn't get file info of `#{retinaPath}`. Error: `#{error}`"
        return

      {width, height} = result
      width = Math.round(width / 2)
      height = Math.round(height / 2)

      opts =
        width: width
        height: height
        alpha: true

      if width > @minWidth and height > @minHeight
        convert retinaPath, normalPath, opts, (error) ->
          if error
            console.error "retina-brunch couldn't convert `#{retinaPath}`. Error: `#{error}`"

  normalExists: (normalPath) ->
    fs.existsSync(normalPath);

  getNormalFilepath: (filepath) ->
    result = @retinaRe.exec filepath
    [original, match] = result
    {index} = result
    "#{filepath[0...index]}#{filepath[index + match.length..]}"













