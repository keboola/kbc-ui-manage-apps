
angular.module('kbc.manageApps')
  .controller('IndexController', [
    "$scope"
    "kbSapiService"
    "kbc.manageApps.config"
    "$http"
    ($scope, storageService, config, $http) ->

      $http(
        url: '/admin/manage-apps/list'
        method: 'GET'
      ).success((data) ->
        console.log 'data', data
      )

      $scope.appName = config.appName
      $scope.buckets = []
      $scope.bucketsLoading = false



  ])