angular
  .module('smn')
  .directive 'kitchensinkGoogleMaps', ($window, supersonic) ->
    restrict: "E"
    template: """<div class="google-maps-container"></div>"""
    replace: true
    scope:
      position: "="
    link: ($scope, element, attr) ->

      # Create map element
      el = document.createElement "div"
      element.prepend el

      # Create map object on the map element
      demoMap = new google.maps.Map el,
        zoom: 9
        mapTypeId: google.maps.MapTypeId.ROADMAP
        disableDefaultUI: true
        draggable: true

      # Create map marker
      demoAccuracyCircle = new google.maps.Circle
        map: demoMap
        fillColor: "#00B5FF"
        fillOpacity: 0
        strokeColor: "#00B5FF"
        strokeOpacity: 0.5
        strokeWeight: 2

      # Create map marker
      demoMarker = new google.maps.Marker
        map: demoMap

      # Method for updating location
      updateLocation = ->
        newLatLng = new google.maps.LatLng $scope.position.latitude, $scope.position.longitude
        demoMap.setCenter newLatLng
        demoMarker.setPosition newLatLng
        demoAccuracyCircle.setCenter newLatLng
        demoAccuracyCircle.setRadius $scope.position.accuracy

      drawStations = ->
        mMarker = new google.maps.Marker
          map: demoMap
        newLatLng2 = new google.maps.LatLng 46.9, 7.47
        mMarker.setPosition newLatLng2
        mMarker = new google.maps.Marker
          map: demoMap
        newLatLng2 = new google.maps.LatLng 47, 7.42
        mMarker.setPosition newLatLng2

      # Watch for changes in position
      $scope.$watch "position", ->
        updateLocation()
      , true

      drawStations()
