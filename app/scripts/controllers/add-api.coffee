angular.module('kbc.manageApps')
.controller('AddApiController', [
    "$scope"
    "kbManageAppsApi"
    "$modalInstance"
    ($scope, manageAppsApi, $modalInstance) ->

      $scope.api =
        id: ''
        uri: ''

      $scope.save = (api) ->
        $scope.resetError()

        manageAppsApi.createApi(api)
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