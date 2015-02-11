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
        zoom: 11
        mapTypeId: google.maps.MapTypeId.ROADMAP
        disableDefaultUI: true
        draggable: true

      # Create map marker
      camMarker = new google.maps.Marker
        map: camMap

      update = ->
        if $scope?.smn?.station?.lat
          # camMap.checkResize
          newLatLng = new google.maps.LatLng $scope.smn.station.lat, $scope.smn.station.lng
          # fix see https://code.google.com/p/gmaps-api-issues/issues/detail?id=1448
          camMarker.setPosition newLatLng
          camMap.setCenter newLatLng
          webcamstravel.easymap.load(camMap)
          camMap.panBy -150, -150
          # map.panTo camMarker.getPosition()
          # google.maps.event.trigger camMap, "resize"
          # camMap.checkResize
          # camMap.panTo newLatLng

      google.maps.event.addListener camMap, "idle", ->
        google.maps.event.trigger camMap, "resize"

      # Watch for changes in position
      $scope.$watch "smn", ->
        update()
      , true
