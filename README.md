retina-brunch
=============

Automatically resizes images labeled at Retina sizes to lower resolutions. Plop an `@2x` image into an `images` folder, and get the normal version too. This must be used with the [Brunch](http://brunch.io) build tool.

Installing
===
**retina-brunch** is designed to be an npm package for use with the build tool Brunch. To install this as a dependency for your Brunch repository, run `npm install --save retina-brunch`, which will add a line to your `package.json` file.

Usage
===
By default, retina-brunch looks in the `images` directory in the `public` folder (the output folder) specified in your Brunch configuration. It then collects all the Retina files matching the regular expression `/(@2[xX])\.(?:gif|jpeg|jpg|png)$/` and creates normal versions by halving the height and width and depositing the file in the same directory as the original.

### Configuration Options
`retina-brunch` can be customized by adding `retina` to the plugins section of your `config.coffee`. The values for each of the options given below are the defaults.

```coffeescript
exports.config =
  plugins:
    retina:
      regexp: /(@2[xX])\.(?:gif|jpeg|jpg|png)$/
      path: 'images'
      assetsPath: 'public'
      minWidth: 0
      minHeight: 0
```

* `RegExp` **regexp** takes a Coffeescript/Javascript regular expression with **exactly one group** (if you specify more, they will be ignored; if you specify fewer, it will break) specifying the string that distinguishes a Retina file from a normal file. By convention, this is normally `@2x` or `@2X`. The name of the normal file will be determined by removing this group. The image resizing tool does not support image formats other than those already specified.
* `String` **path** is the path to your images folder within the `public` folder specified in `config.coffee`, or any directory you want to monitor for files matching the Retina regular expresssion.
* * `String` **assetsPath** allows you to specify a folder other than `public` for retina-brunch to work in. Can be set to e.g. `./app/assets`.
* `Integer` **minHeight** and **minWidth** filter the files which are processed. In particular, a file's dimensions needs to be above **both** the minimum height and width for it to be processed.

Contributing
===

Watch & compile changes: `coffee --watch --output lib/ src/`


Todo
===
It would be interesting to add support for sizes greater than `@2x`. If one specified `@3x` for example, this would generate both a `@2x` and normal version.
