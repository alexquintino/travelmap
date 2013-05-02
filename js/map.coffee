window.TRIP.map  = {

  throttledUpdatePosition : (curPOIIndex) ->

    if curPOIIndex >= 0
      TRIP.scrolling.currentPOIIndex = Math.floor(curPOIIndex)
      nextCoords = @calculateNextCoordinates(curPOIIndex, TRIP.POISOrder)
      TRIP._map.panTo(nextCoords)

#  updatePosition :
#    _.throttle(@throttledUpdatePosition,1)

  calculateNextCoordinates : (currentPOIIndex, POIList) ->
    currentPOIIndexFloored = Math.floor(currentPOIIndex)
    percentageToNextPOI = currentPOIIndex - currentPOIIndexFloored

    currentPOI = POIList[currentPOIIndexFloored]
    nextPOI = POIList[currentPOIIndexFloored + 1]

    nextLatIncrement = (nextPOI.lat - currentPOI.lat) * percentageToNextPOI
    nextLonIncrement = (nextPOI.lon - currentPOI.lon) * percentageToNextPOI

    nextLat = currentPOI.lat + nextLatIncrement
    nextLon = currentPOI.lon + nextLonIncrement
    new google.maps.LatLng(nextLat,nextLon)


  init : (mapElem) ->
    options = {
      center : new google.maps.LatLng(POIS.costaRica.sanJose.lat,POIS.costaRica.sanJose.lon),
      zoom: 10,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDoubleClickZoom: true,
      keyboardShortcuts: false,
      disableDefaultUI: true,
      draggable: false,
      scrollwheel: false,
    }
    TRIP._map = new google.maps.Map(document.getElementById("map_canvas"),options)
    overlay = new google.maps.OverlayView()
    overlay.onAdd = ->
      layer = d3.select(this.getPanes().overlayLayer).append("div").attr("class", "SvgOverlay")
      svg = layer.append("svg")
        .attr("width", mapElem.width())
        .attr("height", mapElem.height())
      mapOverlay = svg.append("g").attr("id", "mapOverlay")

      overlay.draw = ->
        markerOverlay = this
        overlayProjection = markerOverlay.getProjection()

        #Turn the overlay projection into a d3 projection
        TRIP.map.projection = (coordinates) ->
          googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0])
          pixelCoordinates = overlayProjection.fromLatLngToDivPixel(googleCoordinates)
          return [pixelCoordinates.x, pixelCoordinates.y]

        path = d3.geo.path().projection(TRIP.map.projection)
        TRIP.initPaths()
    overlay.setMap(TRIP._map)

  drawPath : (from,to) ->
    fromCoord = @projection([from.lon,from.lat])
    toCoord = @projection([to.lon,to.lat])

    data = [{x: fromCoord[0], y:fromCoord[1]},
            {x: toCoord[0], y:toCoord[1]}]

    line = d3.svg.line()
      .x (d) ->
        return d.x
      .y (d) ->
        return  d.y
      .interpolate("linear")

    d3.select('#mapOverlay').append('path')
      .attr('d',line(data))
      .attr('stroke','blue')
      .attr('stroke-width',2)
}

