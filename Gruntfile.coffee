module.exports = (grunt) ->

  grunt.initConfig
    meta:
      pkg: grunt.file.readJSON('package.json')
      app: 'app'
      src: 'app/assets/javascripts'
      lib: '.grunt/lib'
      plugins: 'app/scripts/plugins'
      style: 'app/assets/stylesheets'
      less: 'app/assets/stylesheets/less'
      css: 'app/assets/stylesheets/css'
      coffee: 'app/assets/javascripts/coffee'
      instrumentDir: 'build/instrument'

    clean: [ 'specs/**/*.js', '<%= meta.css %>/build', 'build','reports', '*.nw']

    coffeelint:
      options:
        indentation: value: 2, level: "error"
        max_line_length: value: 150, level: "warn"
        no_trailing_whitespace: level: "warn"


      scripts:  ['Gruntfile.coffee', 'app/assets/javascripts/coffee/**/*.coffee', 'specs/**/*.coffee']

    jasmine:
      options:
        specs: if grunt.option('tests') then "specs/**/#{grunt.option('tests')}*.js" else 'specs/**/*.spec.js'
        junit:
          path: 'reports'
          consolidate: 'true'
        template: require('grunt-template-jasmine-requirejs')
        templateOptions:
          pathToRequireJS: '.grunt/lib'
          requireConfig:
            baseUrl:  '<%= meta.instrumentDir %>/<%= meta.src %>'
            paths:
              jquery: '../../../../../<%= meta.lib %>/jquery'
              lib: '../../../../../<%= meta.lib %>'
              plugins: '../../../../../<%= meta.plugins %>'



    coffee:
      src:
        options: bare: true
        files: [ expand: true, cwd:  '<%= meta.coffee %>', src:  ['**/*.coffee'], dest: '<%= meta.src %>', ext: '.js' ]

      specs:
        options: bare: true
        files: [ expand: true, cwd: 'specs', src:  ['**/*.coffee'], dest: 'specs', rename: (s, d) -> "specs/#{d.replace('coffee','js')}"]

    uglify:
      production:
        files: [ expand: true, cwd: '<%= meta.src %>', src: ['**/*.js'], dest: '<%= meta.src %>', ext: '.js' ]

    less:
      development:
        options: paths: ["<%= meta.less %>"]
        files: [expand: true, cwd: '<%= meta.less %>/main', src:  ['**/*.less'], dest: 'build/app/assets/stylesheets/css', ext: '.css' ]
      production:
        options: paths: ["<%= meta.less %>/partials"]
        files: [expand: true, cwd: '<%= meta.less %>/main', src:  ['**/*.less'], dest: '<%= meta.css %>', ext: '.css' ]

    stylus:
      development:
#        options: paths: ["<%= meta.style %>"]
        files: [expand: true, cwd: '<%= meta.style %>', src:  ['**/*.styl'], dest: 'app/assets/stylesheets/build/', ext: '.css' ]

    copy:
      dist:
        files: [
          cwd: 'app/',
          expand: true,
          src: ['scripts/**/*.js', '**/*.html', 'images/**/*.*', 'fonts/**/*', "package.json"]
          dest: 'build/app'
        ]

      archive:
        files: [ src: 'build/app.zip', dest: 'package.nw' ]

    watch:
      files: ['<%= meta.coffee %>/**/*.coffee', '<%= meta.less %>/**/*.less', '<%= meta.app %>/**/*.html','<%=meta.style%>/**/*.styl']
      tasks: ['coffee:src', 'less:development', 'stylus:development', 'copy:dist', 'includes:templates', 'copy:archive']

    instrument:
      files: '<%= meta.src %>/**/*.js'
      options:
        basePath: '<%= meta.instrumentDir%>'

    verbosity:
      quiet:
        options: mode: 'hidden'
        tasks: ['clean', 'copy:dist']

    includes:
      templates:
        options:
          includePath: 'app/static_templates'
        cwd: 'build/app'
        src: [ '**/*.html' ]
        dest: 'build/app'

    cssmin:
      minify:
        expand: true
        cwd: '<%= meta.css %>'
        src: ['**/*.css']
        dest: 'build/app/styles/css'

  npmTasks = ['grunt-contrib-jasmine', 'grunt-contrib-coffee', 'grunt-contrib-clean',
              'grunt-contrib-watch', 'grunt-contrib-copy', 'grunt-coffeelint',
              'grunt-contrib-less', 'grunt-istanbul', 'grunt-includes', 'grunt-verbosity','grunt-contrib-uglify',
              'grunt-contrib-cssmin', 'grunt-contrib-stylus']

  grunt.loadNpmTasks(task) for task in npmTasks

  registerTasks =
    'lint': ['coffeelint:scripts']
    'compile_js_development': ['coffee:src', 'coffee:specs']
    'compile_js_production': ['coffee:src', 'coffee:specs', 'uglify:production']
    'compile_css_development': ['less:development', 'stylus:development']
    'compile_css_production': ['less:production', 'cssmin']
    'test': [ 'instrument', 'jasmine']
    'test_development': [ 'verbosity:quiet', 'clean', 'compile_js_development', 'instrument', 'jasmine', 'lint']
    'test_production': [ 'verbosity:quiet', 'clean', 'compile_js_production', 'instrument', 'jasmine', 'lint']
    'dist': ['copy:dist', 'includes:templates', 'copy:archive']
    'package_development': ['test_development', 'compile_css_development', 'dist' ]
    'package': ['test_production', 'compile_css_production', 'dist' ]
    'default': 'package_development'


  grunt.registerTask(k, v) for k,v of registerTasks
