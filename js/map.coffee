window.TRIP.map  = {
  minZoomLevel : 4
  maxZoomLevel : 10

  throttledUpdatePosition : (curPOIIndex) ->
    console.log(curPOIIndex)
    if 0 <= curPOIIndex < 1
      @setZoom @calculateNextZoomLevel(curPOIIndex,@minZoomLevel,@maxZoomLevel)
    else if curPOIIndex >= 1
      curPOIIndex -= 1
      currentPOI = TRIP.pois.currentPOI(curPOIIndex,TRIP.POISOrder)
      nextPOI = TRIP.pois.nextPOI(curPOIIndex,TRIP.POISOrder)
      percentageFromCurrentToNextPOI = TRIP.pois.percentageFromCurrentToNextPOI(curPOIIndex,TRIP.POISOrder)
      console.log("cur:" + currentPOI.name + " next:" + nextPOI.name + " percentage:" + percentageFromCurrentToNextPOI)
      @panTo @calculateNextCoordinates(percentageFromCurrentToNextPOI, currentPOI, nextPOI)


  setZoom : (level) ->
    TRIP._map.setZoom(level)
  panTo: (coords) ->
    googleCoords = new google.maps.LatLng(coords.lat,coords.lon)
    TRIP._map.panTo(googleCoords)

  calculateNextZoomLevel: (curPOIIndex,initialZoom, finalZoom) ->
    diff = finalZoom - initialZoom
    initialZoom + Math.ceil(diff * curPOIIndex)

  calculateNextCoordinates : (percentageFromCurrentToNextPOI, currentPOI, nextPOI) ->
    nextLatIncrement = (nextPOI.lat - currentPOI.lat) * percentageFromCurrentToNextPOI
    nextLonIncrement = (nextPOI.lon - currentPOI.lon) * percentageFromCurrentToNextPOI

    nextLat = currentPOI.lat + nextLatIncrement
    nextLon = currentPOI.lon + nextLonIncrement
    {lat:nextLat, lon:nextLon}

  init : (mapElem) ->
    options = {
      center : new google.maps.LatLng(POIS.costaRica.sanJose.lat,POIS.costaRica.sanJose.lon),
      zoom: 4,
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

