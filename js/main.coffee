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

  TRIP.map.init $("#map_canvas")[0]
  TRIP.pois.loadGeoJson().done () ->
    TRIP.map.initPathOverlay()
  TRIP.pois.loadJson().done () ->
    TRIP.map.setInitialPosition(TRIP.pois.firstPOI())
    TRIP.initDom($("#poi_container"),TRIP.pois.list)
    TRIP.initSkrollr()

  TRIP.scrolling.settings.startingPoint = $(window).height()
  TRIP.scrolling.settings.POIHeight = $(window).height()

