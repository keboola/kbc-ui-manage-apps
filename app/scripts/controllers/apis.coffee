
angular.module('kbc.manageApps')
  .controller('ApisController', [
    "$scope"
    "$modal"
    "kbManageAppsApi"
    "kbAppVersion"
    "apis"
    ($scope, $modal, manageAppsApi, appVersion, apis) ->
      $scope.apis = apis

      $scope.openEditModal = (api) ->
        $modal.open(
          templateUrl: appVersion.versionUrl("views/modals/edit-api.html")
          controller: 'EditApiController'
          resolve:
            api: () ->
              api
        ).result.then((newApi) ->
          $scope.apis = _.filter($scope.apis, (api) ->
            newApi.id != api.id
          )
          $scope.apis.push(newApi)
        )

      $scope.addNewApiModal = ->
        $modal.open(
          templateUrl: appVersion.versionUrl("views/modals/add-api.html")
          controller: 'AddApiController'
        ).result.then((newApi) ->
          $scope.apis.push(newApi)
        )

      $scope.deleteApi = (apiToDelete) ->
        manageAppsApi.deleteApi apiToDelete.id

        $scope.apis = _.filter($scope.apis, (api) ->
          apiToDelete.id != api.id
        )

  ])