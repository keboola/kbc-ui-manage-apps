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
  'ui.router'
  'ngProgress'
])
.config([
  '$stateProvider'
  '$urlRouterProvider'
  '$uiViewScrollProvider'
  '$locationProvider'
  '$tooltipProvider'
  'kbAppVersionProvider'
  'kbc.manageApps.config'
  ($stateProvider, $urlRouterProvider, $uiViewScrollProvider, $locationProvider, $tooltipProvider, appVersionProvider, config) ->
    appVersionProvider
    .setVersion(config.appVersion)
    .setBasePath(config.basePath)

    $tooltipProvider.options(
      appendToBody: true
    )

    $urlRouterProvider.otherwise("/apps")

    $uiViewScrollProvider.useAnchorScroll()

    $stateProvider
      .state('apps',
        url: '/apps'
        templateUrl: appVersionProvider.versionUrl("views/pages/apps.html")
        controller: 'AppsController'
      )
      .state('apps.app',
        url: '/app/:id'
        templateUrl: appVersionProvider.versionUrl("views/pages/app-detail.html")
        controller: "AppsDetailController"
        resolve:
          app: ["kbManageAppsApi", "$stateParams", (api, $stateParams) ->
            api.detail($stateParams.id)
          ]
      )
      .state('apis',
        url: '/apis'
        templateUrl: appVersionProvider.versionUrl("views/pages/apis.html")
        controller: 'ApisController'
        resolve:
          apis: ["kbManageAppsApi", (api) ->
            api.apis()
          ]
      )
      .state('tokens',
        url: '/tokens'
        templateUrl: appVersionProvider.versionUrl("views/pages/tokens.html")
        controller: 'TokensController'
        resolve:
          tokens: ["kbManageAppsApi", (api) ->
            api.tokens()
          ]
      )


    $locationProvider.html5Mode(false)
])

# initialization
.run([
  '$rootScope'
  'kbAppVersion'
  'kbc.manageApps.config'
  '$state'
  '$stateParams'
  ($rootScope,  appVersion, appConfig, $state, $stateParams) ->

    # put configs to rootScope to be simple accesible in all views and controllers
    $rootScope.appVersion = appVersion
    $rootScope.appConfig = appConfig

    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams

])
.run([
    '$rootScope'
    'ngProgress'
    ($rootScope, ngProgress) ->

      $rootScope.$on '$stateChangeStart',  ->
        ngProgress.color('green')
        ngProgress.height(1)
        ngProgress.reset()
        ngProgress.start()

      _.each ['$stateChangeSuccess', '$stateChangeError'], (event) ->
        $rootScope.$on event, ->
          ngProgress.complete()

  ])

.directive 'kbJsonEdit', [->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, ctrl) ->

      ctrl.$formatters.push (value) ->
        if value != null
          angular.toJson value, true
        else
          ''

      ctrl.$parsers.unshift (viewValue) ->
        try
          if viewValue
            data = angular.fromJson viewValue
          else
            data = viewValue
          ctrl.$setValidity 'kbJsonEdit', true
          return data
        catch error
          ctrl.$setValidity 'kbJsonEdit', false
          return undefined
  ]

