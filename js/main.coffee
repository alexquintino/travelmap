window.TRIP = {} if typeof(window.TRIP) is 'undefined'

window.TRIP._vars = {
    scrolling :
      startingPoint : 0
      POIHeight : 0
    windowHeight : 0
}

drawPOI = (poi) ->
  coordinates = googleMapProjection([poi.lon,poi.lat])
  d3.select("#mapOverlay").append('svg:circle')
    .attr('cx', coordinates[0])
    .attr('cy', coordinates[1])
    .attr('r', 5)
    .attr('class',"map-poi")

$ ->
  TRIP.scrollCallback = _.throttle(TRIP.functions.scrollCallback,20)
  height = $(window).height()
  TRIP._vars.scrolling.startingPoint = 0
  TRIP._vars.scrolling.POIHeight = height

  TRIP.map.init $("#map_canvas")[0]
  TRIP.map.loadMapStyles()
  TRIP.pois.loadGeoJson().done () ->
    TRIP.map.initPathOverlay()
  TRIP.pois.loadJson().done () ->
    TRIP.map.setInitialPosition(TRIP.pois.firstPOI())
    TRIP.functions.initDom($("#poi_container"),TRIP.pois.list)
    TRIP.functions.initSkrollr()

