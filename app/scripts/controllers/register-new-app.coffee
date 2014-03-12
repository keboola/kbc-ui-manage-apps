angular.module('kbc.manageApps')
.controller('RegisterNewAppController', [
    "$scope"
    "kbManageAppsApi"
    "$modalInstance"
    ($scope, api, $modalInstance) ->
      $scope.newApp =
        manifestUrl: ''

      $scope.create = () ->
        $scope.resetError()

        api.register($scope.newApp)
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