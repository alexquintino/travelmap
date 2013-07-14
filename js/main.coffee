window.TRIP = {} if typeof(window.TRIP) is 'undefined'

drawPOI = (poi) ->
  coordinates = googleMapProjection([poi.lon,poi.lat])
  d3.select("#mapOverlay").append('svg:circle')
    .attr('cx', coordinates[0])
    .attr('cy', coordinates[1])
    .attr('r', 5)
    .attr('class',"map-poi")

$ ->
  TRIP.scrollCallback = _.throttle(TRIP._scrollCallback,100)
  TRIP.map.setProjection = _.once(TRIP.map._setProjection)

  TRIP.pois.loadGeoJson()
  TRIP.pois.loadJson().done () ->
    TRIP.initDom($("#poi_container"),TRIP.pois.list)
    TRIP.initSkrollr()
  TRIP.map.init($("#map_canvas"))

  TRIP.scrolling.settings.startingPoint = $(window).height()
  TRIP.scrolling.settings.POIHeight = $(window).height()

