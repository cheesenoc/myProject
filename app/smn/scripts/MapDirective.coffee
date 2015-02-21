angular
  .module('smn')
  .directive 'supersonicGoogleMaps', ($window, Smn, supersonic) ->
    restrict: "E"
    template: """<div class="google-maps-container"></div>"""
    replace: true
    scope:
      position: "="
      smns: "="
    link: ($scope, element, attr) ->
      # https://developers.google.com/maps/documentation/javascript/symbols
      cloud =
              #M367 215c45 0 81 -37 81 -83c0 -45 -37 -84 -82 -84h-276c-50 0 -90 42 -90 92c0 40 26 71 61 83c5 28 29 52 59 52c10 0 18 -2 26 -6c19 39 59 67 105 67c64 0 117 -53 117 -117c0 -1 -1 -3 -1 -4z
        path: "M366,154c45,0,81,37,81,83c0,45-37,84-82,84H89c-50,0-90-42-90-92c0-40,26-71,61-83c5-28,29-52,59-52c10,0,18,2,26,6c19-39,59-67,105-67c64,0,117,53,117,117C367,151,366,153,366,154z"
        fillColor: "grey"
        fillOpacity: 0.8
        scale: .1
        strokeColor: "darkgrey"
        strokeWeight: 1
      cloudy =
              #M125 288v0c37 0 68 -26 76 -61h8c36 0 65 -29 65 -65s-29 -66 -65 -66h-157c-28 0 -52 24 -52 53c0 27 21 51 47 53v8c0 43 35 78 78 78z
        path: "M122,61L122,61c36,0,66,25,74,59h7c35,0,63,28,63,63s-28,64-63,64H50c-27,0-50-23-50-51c0-26,20-49,46-51v-7C45,95,80,61,122,61z"
        fillColor: "lightgrey"
        fillOpacity: 0.8
        scale: .1
        strokeColor: "grey"
        strokeWeight: 1
      partlySunny =
              #M144 298v54h16v-54h-16zM0 192v16h55v-16h-55zM44 299l10 11l32 -32l-11 -11zM223 268l-11 11l32 32l11 -11zM56 96l-10 11l31 31l11 -11zM235 224v0c37 0 68 -26 76 -61h8c36 0 65 -29 65 -65s-29 -66 -65 -66h-157c-28 0 -52 24 -52 53c0 27 21 51 47 53v8c0 43 35 78 78 78zM201 252l1 -2v0c-31 -5 -62 -43 -62 -75c0 -2 1 -5 1 -7l-1 -1h-1c-11 -6 -18 -14 -22 -26v1v-1c-23 12 -39 36 -39 63c0 39 32 71 71 71c21 0 39 -9 52 -23z"
        path: "M154.7,83.8V25h-15.7v58.8 M6.9,181.5v-15.7h51.8v15.7H6.9z M49.9,76.8l9.8-10.8L91,97.4l-10.8,10.8L49.9,76.8z M225,107.2l-10.8-10.8l31.3-31.3l10.8,10.8L225,107.2z M61.7,275.4l-9.8-10.8l30.3-30.3L93,245.1L61.7,275.4z M243.8,142.2L243.8,142.2c36.2,0,66.5,25.4,74.3,59.7h7.8c35.2,0,63.6,28.4,63.6,63.6S361.1,330,325.9,330H172.4c-27.4,0-50.9-23.5-50.9-51.8c0-26.4,20.5-49.9,46-51.8v-7.8C167.5,176.4,201.7,142.2,243.8,142.2z M120.7,228.6c-22.5-11.7-40.1-35.3-40.1-61.7c0-38.1,31.3-69.4,69.4-69.4c20.5,0,38.1,8.8,50.9,22.5l1,2l0,0c-30.3,4.9-60.6,42.1-60.6,73.4c0,2,0.8,4.8,1,6.8l0,0l-2.4,0.4c-10.8,5.9-20.3,9.5-29.2,23.3"
        fillColor: "white"
        fillOpacity: 0.8
        scale: .1
        strokeColor: "gold"
        strokeWeight: 1
      sunny =
        path: "M151 296v56h18v-56h-18zM151 32v60h18v-60h-18zM264 183v18h56v-18h-56zM0 183v18h60v-18h-60zM240 130l34 -34l-12 -12l-33 34zM64 306l34 -33l-12 -12l-34 34zM229 272l33 34l12 -12l-34 -33zM52 96l34 34l11 -12l-33 -34zM160 116c-42 0 -76 34 -76 76s34 76 76 76 s76 -34 76 -76s-34 -76 -76 -76z"
        fillColor: "yellow"
        fillOpacity: 0.8
        scale: .1
        strokeColor: "gold"
        strokeWeight: 1

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
        demoMap.panBy -150, -300


      drawStations = ->
        #http://mapicons.nicolasmollet.com/category/markers/nature/weather/
        determineIcon = (sunshine) ->
          if sunshine >= 9
            return sunny
          else if sunshine >= 5
            return partlySunny
          else if sunshine >= 2
            return cloudy
          else
            return cloud
        createMarker = (smn) ->
          latLng = new google.maps.LatLng smn['station'].lat,smn['station'].lng
          marker = new google.maps.Marker
            position: latLng
            map: demoMap
            title: smn['station'].name
            id: smn['station'].code
            icon: determineIcon(smn['sunshine'])
          google.maps.event.addListener marker, "click", ->
            view = new supersonic.ui.View "smn#show?id="+marker.id
            supersonic.ui.layers.push view
            # TODO MKE use parameter to pass id
            # http://docs.appgyver.com/supersonic/guides/navigation/navigating-between-views/layer-stack/
        if $scope.smns.length > 0
          createMarker smn for smn in $scope.smns

      # Watch for changes in position
      $scope.$watch "position", ->
        updateLocation()
      , true

      $scope.$watch "smns", ->
        drawStations()
      , true

      # webcamstravel.easymap.load(demoMap);
