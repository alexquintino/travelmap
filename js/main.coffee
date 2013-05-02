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
    .attr('class',"poi")

TRIP.initPaths = ->
  if $("#mapOverlay path").size() == 0
    TRIP.map.drawPath(POIS.costaRica.sanJose,POIS.costaRica.laFortuna);
    TRIP.map.drawPath(POIS.costaRica.laFortuna,POIS.costaRica.tamarindo);

TRIP.initDom($("body"));
TRIP.map.init($("#map_canvas"));

$ ->

#  $(".poi-label").css("padding-top",$(window).height())
  TRIP.scrolling.settings.startingPoint = $(window).height()
  TRIP.scrolling.settings.POIHeight = $(".poi-label").first().height()

  throttled = _.throttle(TRIP.scrollCallback,100)

  s = skrollr.init {
    render : throttled,
    forceHeight : true,
    smoothScrolling: true
    }