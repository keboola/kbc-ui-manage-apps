angular.module('kbc.manageApps')
.controller('AppDetailController', [
    "$scope"
    "kbManageAppsApi"
    "app"
    ($scope, api, appResponse) ->
      $scope.app = appResponse.data

      $scope.activateVersion = (versionId) ->
        api.activateVersion versionId

        # update local data
        $scope.app.versions = _.map($scope.app.versions, (version) ->
          angular.extend({}, version,
            isActive: versionId == version.id
          )
        )

      $scope.resetNameEdit = ->
        $scope.nameEdit = $scope.app.name

      $scope.saveName = ->
        $scope.app.name = $scope.nameEdit

        api.updateApp(
          id: $scope.app.id
          name: $scope.app.name
        )

      $scope.resetNameEdit()

  ])