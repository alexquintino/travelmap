window.TRIP = {} if typeof(window.TRIP) is 'undefined'

window.TRIP._vars = {
    scrolling :
      startingPoint : $(window).height()*1.5
      POIHeight : $(window).height()
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

  TRIP.map.init $("#map_canvas")[0]
  TRIP.map.loadMapStyles()
  TRIP.pois.loadGeoJson().done () ->
    TRIP.map.initPathOverlay()
  TRIP.pois.loadJson().done () ->
    TRIP.map.setInitialPosition(TRIP.pois.firstPOI())
    TRIP.functions.initDom($("#poi_container"),TRIP.pois.list)
    TRIP.functions.initSkrollr()

