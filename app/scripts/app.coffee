### configuration defaults
  In dev mode injected by bootstrap.coffee script
  I
  n production deployed into kbc provided by kbc
###
angular
.module('kbc.manageApps.config', [])
.constant('kbc.manageApps.config',
  appName: 'kbc.manageApps'
  appVersion: 'v1'
  templatesBasePath: '/app'
  token: {} # token object
  components: [] # list of kbc components provided by https://connection.keboola.com/v2/storage
)

angular
.module('kbc.manageApps', [
  # ng modules
  
  'ngResource'
  'ngSanitize'
  'ngRoute'

  # demo application modules
  'kbc.manageApps.config'

  # keboola common library
  'kb'
  'kb.accordion'
  'kb.i18n'

  # error handling
  'kb.exceptionHandler'

  # third party library modules
  'ui.bootstrap'
  'ui.select2'
  'ngProgress'
])
.config([
  '$routeProvider'
  '$locationProvider'
  '$tooltipProvider'
  'kbAppVersionProvider'
  'kbc.manageApps.config'
  ($routeProvider, $locationProvider, $tooltipProvider, appVersionProvider, config) ->
    appVersionProvider
    .setVersion(config.appVersion)
    .setBasePath(config.basePath)

    $tooltipProvider.options(
      appendToBody: true
    )

    $routeProvider
    .when('/',
        templateUrl: appVersionProvider.versionUrl("views/pages/index.html")
        controller: 'IndexController'
      )
    .when('/apps/:id',
      templateUrl: appVersionProvider.versionUrl("views/pages/app-detail.html")
      controller: "AppDetailController"
      resolve:
        app: ["kbManageAppsApi", "$route", (api, $route) ->
          api.detail($route.current.params.id)
        ]
    )
    .otherwise(
        redirectTo: '/'
      )

    $locationProvider.html5Mode(false)
])

# initialization
.run([
  '$rootScope'
  'kbSapiErrorHandler'
  'kbSapiService'
  'kbAppVersion'
  'kbc.manageApps.config'
  '$route'
  ($rootScope, storageErrorHandler, storageService, appVersion, appConfig, $route) ->

    # put configs to rootScope to be simple accesible in all views and controllers
    $rootScope.appVersion = appVersion
    $rootScope.appConfig = appConfig

    $route.reload()

])
.run([
    '$rootScope'
    'ngProgress'
    ($rootScope, ngProgress) ->

      $rootScope.$on '$routeChangeStart',  ->
        ngProgress.color('green')
        ngProgress.height(1)
        ngProgress.reset()
        ngProgress.start()

      _.each ['$routeChangeSuccess', '$routeChangeError'], (event) ->
        $rootScope.$on event, ->
          ngProgress.complete()

  ])

