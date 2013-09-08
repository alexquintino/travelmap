window.TRIP.map  = {
  minZoomLevel : 4
  maxZoomLevel : 10

  updatePosition : (curPOIIndex,POIsList) ->
    if curPOIIndex >= 1 and curPOIIndex < POIsList.length
      curPOIIndex -= 1
      currentPOI = TRIP.pois.currentPOI(curPOIIndex,POIsList)
      nextPOI = TRIP.pois.nextPOI(curPOIIndex,POIsList)
      percentageFromCurrentToNextPOI = TRIP.pois.percentageFromCurrentToNextPOI(curPOIIndex,TRIP.pois.list)
      @panTo @calculateNextCoordinates(percentageFromCurrentToNextPOI, currentPOI, nextPOI)
      @updateZoomLevel(currentPOI.zoomLevel,nextPOI.zoomLevel,percentageFromCurrentToNextPOI)

  panTo: (coords) ->
    googleCoords = new google.maps.LatLng(coords.lat,coords.lon)
    TRIP._map.panTo(googleCoords)

  updateZoomLevel: (currentPOIZoomLevel, nextPOIZoomLevel,percentageToNextPOI) ->
    unless nextPOIZoomLevel is undefined and currentZoom != nextPOIZoomLevel
      zoomInc = Math.ceil((nextPOIZoomLevel - currentPOIZoomLevel) * percentageToNextPOI)
      newZoom = currentPOIZoomLevel + zoomInc
      TRIP._map.setZoom(newZoom)

  calculateNextCoordinates : (percentageFromCurrentToNextPOI, currentPOI, nextPOI) ->
    d3.geo.projection(@projection)
    coords = d3.geo.interpolate([currentPOI.lon,currentPOI.lat],[nextPOI.lon,nextPOI.lat])(percentageFromCurrentToNextPOI)
    {lat:coords[1],lon:coords[0]}


  init : (mapElem) ->
    TRIP._map = new google.maps.Map(mapElem,@mapOptions())

  setProjection : (overlayProjection) ->
    TRIP.map.projection = (coordinates) ->
      googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0])
      pixelCoordinates = overlayProjection.fromLatLngToDivPixel(googleCoordinates)
      return [pixelCoordinates.x + 5000000, pixelCoordinates.y + 5000000]
    d3.geo.path().projection(TRIP.map.projection)

  drawPaths: () ->
    path = d3.geo.path().projection(@projection)
    d3.select('#mapOverlay').selectAll("path")
      .data(TRIP.pois.geoJson.features)
      .attr("d",path)
      .enter().append("path")
      .attr("d",path)
      .attr("stroke",'blue')
      .attr('stroke-width',2)
      .attr('fill-opacity',0)

  setInitialPosition: (POI) ->
    TRIP._map.setCenter(new google.maps.LatLng(POI.lat,POI.lon))
    TRIP._map.setZoom(POI.zoomLevel)

  mapOptions : () ->
    {
      center : new google.maps.LatLng(0,0),
      zoom: 1
      mapTypeId:google.maps.MapTypeId.ROADMAP,
      disableDoubleClickZoom: true,
      keyboardShortcuts: false,
      disableDefaultUI: true,
      draggable: false,
      scrollwheel: false,
    }

  initPathOverlay: () ->
    overlay = new google.maps.OverlayView()
    overlay.onAdd = ->
      layer = d3.select(this.getPanes().overlayLayer).append("div").attr("class", "SvgOverlay")
      svg = layer.append("svg")
      mapOverlay = svg.append("g").attr("id", "mapOverlay")

      overlay.draw = ->
        markerOverlay = this
        overlayProjection = markerOverlay.getProjection()

        #Turn the overlay projection into a d3 projection
        TRIP.map.setProjection(overlayProjection)

        TRIP.map.drawPaths()
    overlay.setMap(TRIP._map)

  isReady: () ->
    if TRIP._map is undefined or TRIP.map.projection is undefined
      false
    else
      true
}

