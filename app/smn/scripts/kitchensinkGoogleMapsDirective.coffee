angular
  .module('smn')
  .directive 'kitchensinkGoogleMaps', ($window, Smn, supersonic) ->
    restrict: "E"
    template: """<div class="google-maps-container"></div>"""
    replace: true
    scope:
      position: "="
      smns: "="
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
        #http://mapicons.nicolasmollet.com/category/markers/nature/weather/
        determineIcon = (sunshineMinutes) ->
          icon = "icon-question.png"
          if sunshineMinutes
            if sunshineMinutes >= 9
              icon = "sunny.png"
            else if sunshineMinutes >= 3
              icon = "cloudysunny.png"
            else icon = "cloudy.png"  if sunshineMinutes >= 0
          "/icons/" + icon
        createMarker = (smn) ->
          latLng = new google.maps.LatLng smn['station'].lat,smn['station'].lng
          marker = new google.maps.Marker
            position: latLng
            map: demoMap
            title: smn['station'].name
            id: smn['station'].code
            icon: determineIcon(smn['sunshine'])
          google.maps.event.addListener marker, "click", ->
            window.location = "show.html?id=" + marker.id
        createMarker smn for smn in $scope.smns

      # Watch for changes in position
      $scope.$watch "position", ->
        updateLocation()
      , true

      $scope.$watch "smns", ->
        drawStations()
      , true
