angular.module('kbc.manageApps')
.controller('EditApiController', [
    "$scope"
    "kbManageAppsApi"
    "api"
    "$modalInstance"
    ($scope, manageAppsApi, api, $modalInstance) ->

      $scope.api = angular.copy api

      $scope.save = (api) ->
        $scope.resetError()

        manageAppsApi.saveApi(api)
        .success((data) ->
            $modalInstance.close(data)
          )
        .error((error) ->
            $scope.error = error.error
          )

      $scope.resetError = ->
        $scope.error = null

      $scope.close = ->
        $modalInstance.dismiss()

      $scope.resetError()
  ])