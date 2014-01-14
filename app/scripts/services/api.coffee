
angular.module('kbc.manageApps')
  .service 'kbManageAppsApi', ['$http', ($http) ->

    service =
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

