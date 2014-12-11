var solskin = {};

solskin.SmnMarker = function(sourceData, map){
  var latLng = new google.maps.LatLng(sourceData.station.lat, sourceData.station.lng);
  var infoWindowContent = createInfoWindowContent();
  var marker = new google.maps.Marker({
    position: latLng,
    map: map,
    title: sourceData.station.name,
    icon: determineIcon()
  });


  // http://mapicons.nicolasmollet.com/category/markers/nature/weather/
  function determineIcon() {
    var sunshineMinutes = sourceData.sunshine;
    var icon = 'icon-question.png';
    if (sunshineMinutes) {
      if (sunshineMinutes >= 9) {
        icon = 'sunny.png';
      } else if (sunshineMinutes >= 3) {
        icon = 'cloudysunny.png';
      } else if (sunshineMinutes >= 0) {
        icon = 'cloudy.png';
      }
    }
    return '/icons/' + icon;
  }

  function createInfoWindowContent() {
    var sunshineString = sourceData.sunshine ? ((sourceData.sunshine * 10) + '% (' +
    '' + sourceData.sunshine + 'min/10min)') : '-';
    var temperatureString = sourceData.temperature ? sourceData.temperature + '°C' : '-';
    //var date = new Date(sourceData.dateTime);
    var content = '<div id="content">' +
    '<div id="siteNotice"></div>' +
    '<h1 id="firstHeading" class="firstHeading">' + sourceData.station.name + '</h1>' +
    '<div id="bodyContent">' +
    //'<p>time: ' + date.getDate() + '.' + (date.getMonth() + 1) + '.' + date.getFullYear() + ' ' + date.getHours() + ':' + (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes()) + '</p>' +
    '<p>temperature: ' + temperatureString + '</p>' +
    '<p>sunshine: ' + sunshineString + '</p>' +
    '<p><form id="goForm" target="_blank" onsubmit="solskin.setGoFormAction(' + sourceData.station.lat + ', ' + sourceData.station.lng + ')"><input type="text" id="departureField" placeholder="departure point"><input type="submit" value="find"></form></p>' +
    '<p><a href="http://www.lookr.com/map#ll=' + sourceData.station.lat + ',' + sourceData.station.lng + '&spn=0.05,0.05">check nearby webcams</a></p>' +
    '</div>' +
    '</div>';
    return content;
  }

  return {
    getInfoWindowContent: function () {
      return infoWindowContent;
    },
    getLatLng: function () {
      return latLng;
    },
    getMarker: function () {
      return marker;
    }
  }
};

solskin.setGoFormAction = function (toLat, toLng) {
  var from = $("#departureField").val();
  $("#goForm").attr("action", "//www.google.ch/maps/dir/" + from + "/" + toLat + "," + toLng);
};

solskin.initializeMap = function () {
  var bounds, infoWindow, map;

  bounds = new google.maps.LatLngBounds();
  infoWindow = new google.maps.InfoWindow();
  map = new google.maps.Map(document.getElementById("map-canvas"));

  // get JSON-formatted data from the server
  $.getJSON("http://data.netcetera.com/smn/smn", function (response) {

    $.each(response, function (index, item) {
      if (item.sunshine) {
        var smnMarker = solskin.SmnMarker(item, map);
        google.maps.event.addListener(smnMarker.getMarker(), 'click', function () {
          infoWindow.setContent(smnMarker.getInfoWindowContent());
          infoWindow.open(map, smnMarker.getMarker());
        });
        bounds.extend(smnMarker.getLatLng());
      }
    });
    map.fitBounds(bounds);
  });
  solskin.addAdsTo(map);
};

solskin.addAdsTo = function (map) {
  var md = new MobileDetect(window.navigator.userAgent);

  addAdsTop();
  if (!md.phone()) {
    addAdsLeftRight();
  }

  function addAdsTop(){
    var adUnitOptionsTop = {
      format: google.maps.adsense.AdFormat.HALF_BANNER,
      position: google.maps.ControlPosition.TOP
    };
    appendGenericAdUnitOptions(adUnitOptionsTop);
    new google.maps.adsense.AdUnit(document.createElement('div'), adUnitOptionsTop);
  }

  function addAdsLeftRight(){
    var adUnitOptionsLeft, adUnitOptionsRight;

    adUnitOptionsLeft = {
      format: google.maps.adsense.AdFormat.SKYSCRAPER,
      position: google.maps.ControlPosition.LEFT
    };
    adUnitOptionsRight = {
      format: google.maps.adsense.AdFormat.MEDIUM_RECTANGLE,
      position: google.maps.ControlPosition.RIGHT_BOTTOM
    };
    appendGenericAdUnitOptions(adUnitOptionsLeft);
    appendGenericAdUnitOptions(adUnitOptionsRight);

    new google.maps.adsense.AdUnit(document.createElement('div'), adUnitOptionsLeft);
    new google.maps.adsense.AdUnit(document.createElement('div'), adUnitOptionsRight);
  }

  function appendGenericAdUnitOptions(options){
    options.backgroundColor = '#eeeeee';
    options.publisherId = 'pub-6730585621400353';
    options.borderColor = '#BA025C';
    options.titleColor = '#333333';
    options.textColor = '#666666';
    options.urlColor = '#BA025C';
    options.map = map;
    options.visible = true;
  }

  return {};
};
google.maps.event.addDomListener(window, 'load', solskin.initializeMap);
