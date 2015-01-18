angular
  .module('smn')
  .controller("IndexController", ($scope, Smn, supersonic, CalculationService) ->
    $scope.smns = null
    $scope.showSpinner = true
    $scope.sun_predicate = ['-icon','+distance']
    $scope.predicate = $scope.sun_predicate
    $scope.reverse = false

    refresh = ->
      Smn.all().whenChanged (smns) ->
        $scope.$apply ->
          $scope.smns = smns
          $scope.getPosition()

    update = ->
      if document.visibilityState == "visible"
        $scope.showSpinner = true
        refresh()

    document.addEventListener "visibilitychange", update, false

    extendSmn = (smn) ->
      smn['name'] = smn['station'].name
      smn['distance'] = CalculationService.Haversine($scope.position.coords.latitude,$scope.position.coords.longitude,smn['station'].lat,smn['station'].lng)
      #console.log smn['distance']
      smn['icon'] = CalculationService.Icon(smn['sunshine'])

    # Initial position at (0,0)
    $scope.position =
      latitude: 46.9
      longitude: 7.47

    # Are we currently gettting position?
    $scope.isGettingPosition = false

    # TODO MKE use this for prod
    # Method for getting user's current position now
    $scope.getPosition = ->
      return if $scope.isGettingPosition
      $scope.isGettingPosition = true
      supersonic.device.geolocation.getPosition()
        .then (position) ->
          $scope.position = position
          extendSmn smn for smn in $scope.smns
        .finally ->
          $scope.isGettingPosition = false
          $scope.showSpinner = false

    # Get position on when view is shown
    supersonic.ui.views.current.whenVisible ->
      $scope.getPosition()

    # $scope.getPosition = () ->
    #   position =
    #     coords:
    #       latitude: 46.9
    #       longitude: 7.47
    #   $scope.position = position
    #   extendSmn smn for smn in $scope.smns

    refresh()

  )
