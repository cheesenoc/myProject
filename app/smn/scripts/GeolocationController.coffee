angular
  .module('smn')
  .controller 'GeolocationController', ($scope, supersonic, $timeout) ->

    # Initial position at (0,0)
    $scope.position =
      latitude: 0
      longitude: 0
      accuracy: 100

    # Are we currently gettting position?
    $scope.isGettingPosition = false

    # Method for getting user's current position now
    $scope.getPosition = ->
      return if $scope.isGettingPosition
      $scope.isGettingPosition = true
      supersonic.device.geolocation.getPosition()
        .then (position) ->
          $scope.position = position.coords
        .finally ->
          $scope.isGettingPosition = false

    # Get position on when view is shown
    supersonic.ui.views.current.whenVisible ->
      $scope.getPosition()

    # Let's get initial location on when view is created
    # This is just to make the map targeted to current location before the view is opened
    $scope.getPosition()
