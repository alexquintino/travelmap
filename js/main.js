(function() {
  var drawPOI, scrollCallback;

  if (typeof window.TRIP === 'undefined') {
    window.TRIP = {};
  }

  TRIP.POISOrder = [POIS.costaRica.sanJose, POIS.costaRica.laFortuna, POIS.costaRica.tamarindo, POIS.costaRica.PenasBlancas];

  TRIP.numberOfPOIS = TRIP.POISOrder.length;

  scrollCallback = function(props) {
    return TRIP.updateMapPosition(props.curTops);
  };

  drawPOI = function(poi) {
    var coordinates;

    coordinates = googleMapProjection([poi.lon, poi.lat]);
    return d3.select("#mapOverlay").append('svg:circle').attr('cx', coordinates[0]).attr('cy', coordinates[1]).attr('r', 5).attr('class', "poi");
  };

  TRIP.initPaths = function() {
    if ($("#mapOverlay path").size() === 0) {
      TRIP.drawPath(POIS.costaRica.sanJose, POIS.costaRica.laFortuna);
      return TRIP.drawPath(POIS.costaRica.laFortuna, POIS.costaRica.tamarindo);
    }
  };

  TRIP.initDom($("body"));

  TRIP.initMap($("#map_canvas"));

  $(function() {
    return $(".poi-label").css("margin-top", $(window).height());
  });

}).call(this);
