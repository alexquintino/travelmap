window.TRIP = {} if typeof(window.TRIP) is 'undefined'

TRIP.POISOrder = [
  POIS.costaRica.sanJose,
  POIS.costaRica.laFortuna,
  POIS.costaRica.tamarindo,
  POIS.costaRica.PenasBlancas]

TRIP.scrollCallback = (props) ->
  currentPOIIndex = TRIP.pois.calculateCurrentPOIIndex(props.curTop,TRIP.scrolling.settings)
  TRIP.map.throttledUpdatePosition(currentPOIIndex)

drawPOI = (poi) ->
  coordinates = googleMapProjection([poi.lon,poi.lat])
  d3.select("#mapOverlay").append('svg:circle')
    .attr('cx', coordinates[0])
    .attr('cy', coordinates[1])
    .attr('r', 5)
    .attr('class',"map-poi")

TRIP.drawPaths = ->
  if $("#mapOverlay path").size() == 0
    TRIP.map.drawPath(POIS.costaRica.sanJose,POIS.costaRica.laFortuna);
    TRIP.map.drawPath(POIS.costaRica.laFortuna,POIS.costaRica.tamarindo);

TRIP.map.init($("#map_canvas"));
TRIP.initDom($("#poi_container"));

$ ->
  TRIP.scrolling.settings.startingPoint = $(window).height()
  TRIP.scrolling.settings.POIHeight = $(window).height()

  throttled = _.throttle(TRIP.scrollCallback,100)
  TRIP.map.setProjection = _.once(TRIP.map._setProjection)


  TRIP.scrolling.skrollr = skrollr.init {
    render : throttled,
    forceHeight : true,
    smoothScrolling: true
    }