angular
  .module('smn')
  .factory("CalculationService", () ->
    Radians = (degrees) ->
      degrees /  57.2957795

    Haversine = (lat1, lon1, lat2, lon2) ->
      #console.log lat1, lon1, lat2, lon2
      R = 6371 # km
      dLat = Radians(lat2-lat1)
      dLon = Radians(lon2-lon1)
      a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(Radians(lat1)) * Math.cos(Radians(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      Math.round(R * c)

    Icon = (sunshine) ->
      if sunshine >= 9
        return 'svg-ios7-sunny-outline'
      else if sunshine >= 5
        return 'svg-ios7-partlysunny-outline'
      else if sunshine >= 2
        return 'svg-ios7-cloudy-outline'
      else
        return 'svg-ios7-cloud-outline'

    Haversine: Haversine
    Icon: Icon
  )
