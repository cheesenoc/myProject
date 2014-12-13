var solskin = {};

solskin.SmnMarker = function(sourceData, map){
  var latLng = new google.maps.LatLng(sourceData.station.lat, sourceData.station.lng);
  var marker = new google.maps.Marker({
    position: latLng,
    map: map,
    title: sourceData.station.name,
    id: sourceData.station.code,
    icon: determineIcon()
  });


  // http://mapicons.nicolasmollet.com/category/markers/nature/weather/
  function determineIcon() {
    var sunshineMinutes = sourceData.sunshine;
    var icon = 'cloudy.png';
    if (sunshineMinutes) {
      if (sunshineMinutes >= 9) {
        icon = 'sunny.png';
      } else if (sunshineMinutes >= 3) {
        icon = 'cloudysunny.png';
      } 
    }
    return '/icons/' + icon;
  }

  return {
    getLatLng: function () {
      return latLng;
    },
    getMarker: function () {
      return marker;
    }
  }
};



solskin.initializeMap = function () {
  var bounds, map;

  bounds = new google.maps.LatLngBounds();
  map = new google.maps.Map(document.getElementById("map-canvas"));

  // get JSON-formatted data from the server
  $.getJSON("http://data.netcetera.com/smn/smn", function (response) {

    $.each(response, function (index, item) {
      if (item.sunshine) {
        var smnMarker = solskin.SmnMarker(item, map);
        google.maps.event.addListener(smnMarker.getMarker(), 'click', function () {
          window.location = "show.html?id=" + smnMarker.getMarker().id;
        });
        bounds.extend(smnMarker.getLatLng());
      }
    });
    map.fitBounds(bounds);
  });
};


google.maps.event.addDomListener(window, 'load', solskin.initializeMap);
