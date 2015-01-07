angular
  .module('smn')
  .directive 'supersonicGoogleMapsCam', ($window, supersonic) ->
    restrict: "E"
    template: """<div class="google-maps-container-cam"></div>"""
    replace: true
    scope:
      smn: "="
    link: ($scope, element, attr) ->
      # Create map element
      cel = document.createElement "div"
      element.prepend cel

      # Create map object on the map element
      camMap = new google.maps.Map cel,
        zoom: 10
        mapTypeId: google.maps.MapTypeId.ROADMAP
        disableDefaultUI: true
        draggable: true

      # Create map marker
      camMarker = new google.maps.Marker
        map: camMap

      update = ->
        # newLatLng = new google.maps.LatLng $scope.position.latitude, $scope.position.longitude
        newLatLng = if $scope.smn then new google.maps.LatLng $scope.smn.station.lat, $scope.smn.station.lng else new google.maps.LatLng 46.9, 7.47
        camMap.setCenter newLatLng
        camMarker.setPosition newLatLng

        webcamstravel.easymap.load(camMap);

      # Watch for changes in position
      $scope.$watch "smn", ->
        update()
      , true
