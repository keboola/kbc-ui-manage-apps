###
  Mockup bootstrap
###

jQuery( ->
  appName = 'kbc.manageApps'

  startApp = (configuration) ->
    # create configuration
    angular.module(appName)
    .constant("#{appName}.config",
        basePath: '/'
        appName: appName
      )

    angular.bootstrap(angular.element.find('body'), [appName])

  startApp()
)

