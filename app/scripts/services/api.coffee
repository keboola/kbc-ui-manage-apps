
angular.module('kbc.manageApps')
  .service 'kbManageAppsApi', ['$http', ($http) ->

    service =
      apis: ->
        $http(
          url: '/admin/manage-apps/apis-list'
          method: 'GET'
        )
        .then((response) ->
          response.data.apis
        )

      tokens: ->
        $http(
          url: '/admin/manage-apps/tokens-list'
          method: 'GET'
        )
        .then((response) ->
          response.data.tokens
        )
      createToken: (token) ->
        $http.post("/admin/manage-apps/token-create", token)
      deleteToken: (tokenId) ->
        $http.delete("/admin/manage-apps/token-delete/id/#{tokenId}")
      saveApi: (api) ->
        $http.post("/admin/manage-apps/api-update", JSON.stringify(api))
      createApi: (api) ->
        $http.post("/admin/manage-apps/api-create", JSON.stringify(api))
      deleteApi: (apiId) ->
        $http.delete("/admin/manage-apps/api-delete/id/#{apiId}")
      index: ->
        $http(
          url: '/admin/manage-apps/list'
          method: 'GET'
        )
      detail: (appId) ->
        $http(
          url: "/admin/manage-apps/detail/id/#{appId}"
          method: 'GET'
        )
      activateVersion: (versionId) ->
        $http.post('/admin/manage-apps/activate',
          versionId: versionId
        )
      updateApp: (data) ->
        $http.post('/admin/manage-apps/update', data)
      register: (data) ->
        $http.post('/admin/manage-apps/register', data)

    service
  ]

