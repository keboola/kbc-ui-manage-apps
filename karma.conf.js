
        // Karma configuration

// Karma configuration
// http://karma-runner.github.io/0.10/config/configuration-file.html

module.exports = function(config) {
    config.set({
        // base path, that will be used to resolve files and exclude
        basePath: '',

        // testing framework to use (jasmine/mocha/qunit/...)
        frameworks: ['jasmine'],

        // list of files / patterns to load in the browser
        files: [
            'test/helpers.coffee',
            'app/components/angular/angular.js',
           'app/components/angular-mocks/angular-mocks.js',
              'app/components/angular-resource/angular-resource.js',
              'app/components/angular-sanitize/angular-sanitize.js',
              'app/components/angular-route/angular-route.js',
              'app/components/angular-kb/docs/build/angular-kb.js',
            'app/components/angular-ui-bootstrap-bower/ui-bootstrap-tpls.js',
            'app/components/underscore/underscore.js',
            'app/components/jquery/jquery.js',
            'app/scripts/*.coffee',
            'app/scripts/**/*.coffee'
        ],

        // list of files / patterns to exclude
        exclude: [],

        // web server port
        port: 8080,

        // level of logging
        // possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
        logLevel: config.LOG_INFO,


        // enable / disable watching file and executing tests whenever any file changes
        autoWatch: false,


        // Start these browsers, currently available:
        // - Chrome
        // - ChromeCanary
        // - Firefox
        // - Opera
        // - Safari (only Mac)
        // - PhantomJS
        // - IE (only Windows)
        browsers: ['Chrome'],


        // Continuous Integration mode
        // if true, it capture browsers, run tests and exit
        singleRun: false
    });
};
