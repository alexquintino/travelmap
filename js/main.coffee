window.TRIP = {} if typeof(window.TRIP) is 'undefined'

TRIP.POISOrder = [
  POIS.costaRica.sanJose,
  POIS.costaRica.laFortuna,
  POIS.costaRica.tamarindo,
  POIS.costaRica.PenasBlancas]

TRIP.numberOfPOIS = TRIP.POISOrder.length

scrollCallback = (props) ->
  TRIP.updateMapPosition(props.curTops)

drawPOI = (poi) ->
  coordinates = googleMapProjection([poi.lon,poi.lat])
  d3.select("#mapOverlay").append('svg:circle')
    .attr('cx', coordinates[0])
    .attr('cy', coordinates[1])
    .attr('r', 5)
    .attr('class',"poi")

TRIP.initPaths = ->
  if $("#mapOverlay path").size() == 0
    TRIP.drawPath(POIS.costaRica.sanJose,POIS.costaRica.laFortuna);
    TRIP.drawPath(POIS.costaRica.laFortuna,POIS.costaRica.tamarindo);

TRIP.initDom($("body"));
TRIP.initMap($("#map_canvas"));

$ ->
  $(".poi-label").css("margin-top",$(window).height())

#  s = skrollr.init {
#    render : scrollCallback,
#    forceHeight : true,
#    smoothScrolling: true
#    }