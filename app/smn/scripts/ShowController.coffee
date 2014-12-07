angular
  .module('smn')
  .controller("ShowController", ($scope, Smn, supersonic, CalculationService) ->
    $scope.smn = null
    $scope.showSpinner = true
    $scope.dataId = undefined
    position =
      coords:
        latitude: 46.9
        longitude: 7.47
    $scope.position = position

    _refreshViewData = ->
      Smn.find($scope.dataId).then (smn) ->
        $scope.$apply ->
          smn['distance'] = CalculationService.Haversine($scope.position.coords.latitude,$scope.position.coords.longitude,smn['station'].lat,smn['station'].lng)
          #console.log smn['distance']
          smn['icon'] = CalculationService.Icon(smn['sunshine'])
          $scope.smn = smn
          $scope.showSpinner = false

    supersonic.ui.views.current.whenVisible ->
      _refreshViewData() if $scope.dataId

    supersonic.ui.views.current.params.onValue (values) ->
      $scope.dataId = values.id
      _refreshViewData()

  )
