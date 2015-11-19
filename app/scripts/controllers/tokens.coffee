
angular.module('kbc.manageApps')
.controller('TokensController', [
    "$scope"
    "$modal"
    "kbManageAppsApi"
    "kbAppVersion"
    "tokens"
    ($scope, $modal, manageAppsApi, appVersion, tokens) ->
      $scope.tokens = tokens
      $scope.newToken = null


      $scope.addNewTokenModal = ->
        $modal.open(
          templateUrl: appVersion.versionUrl("views/modals/add-token.html")
          controller: 'AddTokenController'
        ).result.then((newToken) ->
          $scope.tokens.push(newToken)
          $scope.newToken = newToken
        )

      $scope.deleteToken = (token) ->
        manageAppsApi.deleteToken token.id

        $scope.tokens = _.filter($scope.tokens, (currentToken) ->
          token.id != currentToken.id
        )
  ])
