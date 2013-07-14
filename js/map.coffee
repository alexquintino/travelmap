window.TRIP.map  = {
  minZoomLevel : 4
  maxZoomLevel : 10

  updatePosition : (curPOIIndex) ->
    if curPOIIndex >= 1
      curPOIIndex -= 1
      currentPOI = TRIP.pois.currentPOI(curPOIIndex,TRIP.POISOrder)
      nextPOI = TRIP.pois.nextPOI(curPOIIndex,TRIP.POISOrder)
      percentageFromCurrentToNextPOI = TRIP.pois.percentageFromCurrentToNextPOI(curPOIIndex,TRIP.POISOrder)
      @panTo @calculateNextCoordinates(percentageFromCurrentToNextPOI, currentPOI, nextPOI)

  panTo: (coords) ->
    googleCoords = new google.maps.LatLng(coords.lat,coords.lon)
    TRIP._map.panTo(googleCoords)

  calculateNextCoordinates : (percentageFromCurrentToNextPOI, currentPOI, nextPOI) ->
    nextLatIncrement = (nextPOI.lat - currentPOI.lat) * percentageFromCurrentToNextPOI
    nextLonIncrement = (nextPOI.lon - currentPOI.lon) * percentageFromCurrentToNextPOI

    nextLat = currentPOI.lat + nextLatIncrement
    nextLon = currentPOI.lon + nextLonIncrement
    {lat:nextLat, lon:nextLon}

  init : (mapElem,overlay_callback) ->
    TRIP._map = new google.maps.Map(mapElem,@mapOptions())
    overlay = new google.maps.OverlayView()
    overlay.onAdd = ->
      layer = d3.select(this.getPanes().overlayLayer).append("div").attr("class", "SvgOverlay")
      svg = layer.append("svg")
      mapOverlay = svg.append("g").attr("id", "mapOverlay")
      overlay_callback.call()

    overlay.draw = ->
      markerOverlay = this
      overlayProjection = markerOverlay.getProjection()

      #Turn the overlay projection into a d3 projection
      TRIP.map.setProjection(overlayProjection)

#      TRIP.map.drawPaths()
    overlay.setMap(TRIP._map)

  _setProjection : (overlayProjection) ->
    TRIP.map.projection = (coordinates) ->
      googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0])
      pixelCoordinates = overlayProjection.fromLatLngToDivPixel(googleCoordinates)
      return [pixelCoordinates.x + 4000, pixelCoordinates.y + 4000]
    d3.geo.path().projection(TRIP.map.projection)

  drawPaths: () ->
    path = d3.geo.path()
    path.projection(@projection)
    d3.select('#mapOverlay').selectAll("path")
      .data(TRIP.pois.geoJson.features)
      .enter().append("path")
      .attr("d",path)
      .attr("stroke",'blue')
      .attr('stroke-width',2)
      .attr('fill-opacity',0)


  mapOptions : () ->
    {
      #San Jose, Costa Rica
      center : new google.maps.LatLng(9.93,-84.08),
      zoom: 4,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDoubleClickZoom: true,
      keyboardShortcuts: false,
      disableDefaultUI: true,
      draggable: false,
      scrollwheel: false,
    }
}

