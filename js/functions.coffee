window.TRIP = {
  initDom : (element) ->
    labels = ["SAN JOSÉ","LA FORTUNA", "TAMARINDO", "ISLA DE OMETEPE"]
    _.each labels, (label) ->
      html = _.template("<div class=\"poi-label\" data-bottom-top=\"left:-50%\" data-100-top=\"left:0%\"><h1><%= label %></h1></div>",{label: label})
      element.append(html);

  initMap : (mapElem) ->
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
    TRIP.map = new google.maps.Map(document.getElementById("map_canvas"),options)
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
        TRIP.googleMapProjection = (coordinates) ->
          googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0])
          pixelCoordinates = overlayProjection.fromLatLngToDivPixel(googleCoordinates)
          return [pixelCoordinates.x, pixelCoordinates.y]

        path = d3.geo.path().projection(TRIP.googleMapProjection)
        TRIP.initPaths()
    overlay.setMap(TRIP.map);

  drawPath : (from,to) ->
    fromCoord = TRIP.googleMapProjection([from.lon,from.lat])
    toCoord = TRIP.googleMapProjection([to.lon,to.lat])

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

  updateMapPosition : (currentTop) ->
#		windowHeight = $(window).height();
#		poiIndex = Math.floor((currentTop+windowHeight) / windowHeight);
#		console.log(poiIndex);
#   console.log($(".rendered").text())
    console.log(currentTop)
}
