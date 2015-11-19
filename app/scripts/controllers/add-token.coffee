angular.module('kbc.manageApps')
.controller('AddTokenController', [
    "$scope"
    "kbManageAppsApi"
    "$modalInstance"
    ($scope, manageAppsApi, $modalInstance) ->

      $scope.token =
        description: ''
        scopes: ''

      $scope.save = (token) ->
        $scope.resetError()

        manageAppsApi.createToken(token)
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
