"use strict"


module.exports = (grunt) ->

  # load all grunt tasks
  require('load-grunt-tasks')(grunt)

  require('time-grunt')(grunt)

  proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest

  mountFolder = (connect, dir) ->
    connect.static require("path").resolve(dir)


  _ = require('lodash')

  awsDefaults = {}
  if grunt.file.exists('./aws-keys.json')
    awsDefaults = grunt.file.readJSON('./aws-keys.json')

  grunt.initConfig(
    yeoman:
      app: require('./bower.json').appPath || 'app'
      dist: 'dist'
    bower: grunt.file.readJSON("./bower.json")
    watch:
      compass:
        files: ['<%= yeoman.app %>/styles/*.{scss,sass}'],
        tasks: ['compass:server']
      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}*.coffee"]
        tasks: ["newer:coffee:dist"]
      coffeeBootstrap:
        files: ["<%= yeoman.app %>/bootstrap.coffee"]
        tasks: ["newer:coffee:bootstrap"]


      livereload:
        options:
          livereload: '<%= connect.options.livereload %>'
        files: [
          "<%= yeoman.app %>/{,*/}*.html",
          ".tmp/styles/{,*/}*.css",
          ".tmp/scripts/{,*/}*.js",
          ".tmp/bootstrap.js",
          "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]

    connect:
      proxies: [
        {
          context: '/admin'
          host: 'connection.keboola.com'
          port: 443
          changeOrigin: true
          https: true
        }
      ]
      options:
        port: 9000
        hostname: "localhost"
        livereload: 35729

      livereload:
        options:
          open: true
          base: ['.tmp', '<%= yeoman.app %>']
          middleware: (connect) ->
            [
              proxySnippet
              mountFolder(connect, '.tmp')
              mountFolder(connect, 'app')
            ]

      test:
        options:
          port: 9001
          base: ['.tmp', '<%= yeoman.app %>']

      dist:
        options:
          base: '<%= yeoman.dist %>'


    clean:
      dist:
        files: [
          dot: true
          src: [".tmp", "release/*", "<%= yeoman.dist %>/*", "!<%= yeoman.dist %>/.git*"]
        ]

      server: ".tmp"

    compass:
      options:
        sassDir: '<%= yeoman.app %>/styles',
        cssDir: '.tmp/styles',
        generatedImagesDir: '.tmp/images/generated',
        imagesDir: '<%= yeoman.app %>/styles/images',
        javascriptsDir: '<%= yeoman.app %>/scripts',
        fontsDir: '<%= yeoman.app %>/components/font-awesome/fonts',
        importPath: '<%= yeoman.app %>',
        httpImagesPath: '/styles/images',
        httpGeneratedImagesPath: '/images/generated',
        httpFontsPath: '/styles/fonts',
        relativeAssets: false,
        assetCacheBuster: false
      dist:
        options:
          generatedImagesDir: '<%= yeoman.dist %>/images/generated'
      server:
        options:
          debugInfo: true

    karma:
      unit:
        configFile: "karma.conf.js"
        singleRun: true

    coffee:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: '{,*/}*.coffee',
          dest: ".tmp/scripts"
          ext: ".js"
        ]

      bootstrap:
        src: ["<%= yeoman.app %>/bootstrap.coffee"]
        dest: ".tmp/bootstrap.js"

    coffeelint:
      options:
        max_line_length:
          level: 'warn'
          value: 120
      dist:
        files: '<%= coffee.dist.files %>'
      grunt:
        src: ['Gruntfile.coffee']
    concat: {}
  # filled by useminPrepare from index.html

    useminPrepare:
      html: "<%= yeoman.app %>/index.html"
      options:
        dest: "<%= yeoman.dist %>"

    usemin:
      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        dirs: ["<%= yeoman.dist %>"]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>/images"
        ]

    cssmin: {}

    htmlmin:
      dist:
        options: {}

      #removeCommentsFromCDATA: true,
      #          // https://github.com/yeoman/grunt-usemin/issues/44
      #          //collapseWhitespace: true,
      #          collapseBooleanAttributes: true,
      #          removeAttributeQuotes: true,
      #          removeRedundantAttributes: true,
      #          useShortDoctype: true,
      #          removeEmptyAttributes: true,
      #          removeOptionalTags: true
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: ["*.html", "views/**/*.html"]
          dest: "<%= yeoman.dist %>"
        ]

    ngmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.dist %>/scripts"
          src: "*.js"
          dest: "<%= yeoman.dist %>/scripts"
        ]

    uglify: {}

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: ["*.{ico,txt}", ".htaccess", "components/**/*", "images/{,*/}*.{gif,webp}"]
        ,
          expand: true
          dot: true
          cwd: ".tmp"
          dest: "<%= yeoman.dist %>"
          src: ["bootstrap.js"]
        ]


      styles:
        expand: true,
        dot: true,
        cwd: '<%= yeoman.app %>/styles',
        dest: '.tmp/styles/',
        src: '{,*/}*.css'

      release:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.dist %>"
          dest: "release"
          src: ["images/**/*.{gif,webp}", "styles/*", "scripts/*", "views/**"]
        ,
          expand: true
          cwd: "<%= yeoman.app %>"
          dest: "release"
          src: ["components/font-awesome/fonts/**"]
        ,
          dest: "release/styles/select2.png"
          src: ["<%= yeoman.dist %>/components/select2/select2.png"]
        ]

    'aws_s3':
      release:
        options:
          _.extend(awsDefaults,
            bucket: "kbc-uis"
            params:
              CacheControl: 'max-age=315360000, public'
          )

        files: []

    "git-describe":
      dist: {}
  )

  ###
    Read current git revision into configuration
  ###
  grunt.registerTask "read-revision", ->
    grunt.event.once "git-describe", (rev) ->
      grunt.log.writeln "Git Revision: " + rev[0]
      grunt.config "gitRevision", rev[0]

    grunt.task.run "git-describe"

  appS3Path = () ->
    grunt.config("bower.name") + "/" + grunt.config("gitRevision") + "/"

  appS3FullPath = () ->
    s3basePath = "https://" + grunt.config("aws_s3.release.options.bucket") + ".s3.amazonaws.com/"
    s3basePath += appS3Path()
    s3basePath

  ###
    Release manifest
    Describes javascript files and stylesheet to include
    Manifest can be registered into Keboola Connection
  ###
  grunt.registerTask "generate-manifest", ->
    grunt.task.requires "read-revision"
    s3fullPath = appS3FullPath()

    manifest =
      name: grunt.config("bower.name")
      version: grunt.config("gitRevision")
      basePath: s3fullPath

    manifest.scripts = grunt.file.expand(
      cwd: 'release',
      'scripts/*'
    ).map((script) ->
      s3fullPath + script
    )

    manifest.styles = grunt.file.expand(
      cwd: 'release',
      'styles/*'
    ).map((script) ->
      s3fullPath + script
    )

    grunt.file.write('release/manifest.json', JSON.stringify(manifest))

  ###
    Upload current build into S3 under current revision path
  ###
  grunt.registerTask "upload-revision", ->
    grunt.task.requires "generate-manifest"
    grunt.log.writeln "uploading revision: " + grunt.config.get("gitRevision")

    # set s3 path
    grunt.config "aws_s3.release.files", [
      expand: true
      cwd: "release"
      src: ["**"]
      dest: appS3Path()
    ]
    grunt.task.run "aws_s3"

  grunt.registerTask "print-manifest-path", ->
    grunt.log.ok('Install manifest into KBC:')
    grunt.log.ok(appS3FullPath() + "manifest.json")

  grunt.registerTask "upload-release", [
    "read-revision"
    "generate-manifest"
    "upload-revision"
    "print-manifest-path"
  ]



  grunt.registerTask 'server', (target) ->

    if target == 'dist'
      return grunt.task.run ['build', 'connect:dist:keepalive']

    grunt.task.run([
      "clean:server"
      "coffeelint:dist"
      "coffee:dist"
      "coffee:bootstrap"
      "compass:server"
      "copy:styles"
      'configureProxies'
      "connect:livereload"
      "watch"
    ])


  grunt.registerTask "test", [
    "clean:server"
    "coffee"
    "connect:test"
    "karma"
  ]

  grunt.registerTask "build", [
    "clean:dist"
    "coffeelint"
    "coffee"
    "useminPrepare"
    "compass"
    "copy:styles"
    "imagemin",
    "concat"
    "cssmin"
    "htmlmin"
    "ngmin"
    "uglify"
    "copy:dist"
    "usemin"
    "copy:release"
  ]

  grunt.registerTask "default", ["build"]
  grunt.registerTask "devel", ["server"]