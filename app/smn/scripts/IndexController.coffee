angular
  .module('smn')
  .controller("IndexController", ($scope, Smn, supersonic, CalculationService) ->
    $scope.smns = null
    $scope.showSpinner = true
    $scope.predicate = 'distance'
    $scope.reverse = false

    extendSmn = (smn) ->
      smn['name'] = smn['station'].name
      smn['distance'] = CalculationService.Haversine($scope.position.coords.latitude,$scope.position.coords.longitude,smn['station'].lat,smn['station'].lng)
      #console.log smn['distance']
      smn['icon'] = CalculationService.Icon(smn['sunshine'])

    $scope.getPosition = () ->
      position =
        coords:
          latitude: 46.9
          longitude: 7.47
      $scope.position = position
      extendSmn smn for smn in $scope.smns

    # $scope.getPosition = () ->
    #   supersonic.device.geolocation.getPosition().then (position) ->
    #     $scope.position = position
    #     extendSmn smn for smn in $scope.smns

    Smn.all().whenChanged (smns) ->
      $scope.$apply ->
        $scope.smns = smns
        $scope.getPosition()
        $scope.showSpinner = false

  )
