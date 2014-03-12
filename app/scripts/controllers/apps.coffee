angular.module('kbc.manageApps')
.controller('AppsController', [
    "$scope",
    "$rootScope",
    "kbManageAppsApi"
    "$location"
    "$modal"
    "kbAppVersion"
    ($scope, $rootScope, api, $location, $modal, appVersion) ->
      $scope.apps = []
      $scope.projects = []

      api
      .index()
      .success((index) ->
          $scope.apps = index.apps
          $scope.projects = index.projects
        )

      $scope.preview =
        projectId: null

      $scope.openApp = (id) ->
        $location.path("/apps/app/#{id}")

      $scope.addApp = (app) ->
        foundApp = _.find($scope.apps, (checkApp) ->
          checkApp.id == app.id)
        return if foundApp
        $scope.apps.push app

      $scope.registerNewAppModal = () ->
        $modal.open(
          templateUrl: appVersion.versionUrl("views/modals/register-new-app.html")
          controller: 'RegisterNewAppController'
        ).result.then((result) ->
          $scope.addApp(result.app)
          $scope.openApp(result.app.id)
        )


  ])