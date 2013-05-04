(function() {
  window.TRIP.pois = {
    calculateCurrentPOIIndex: function(scrollTop, settings) {
      var POIHeight, POIIndex, adjustedScrollTop, startingPoint;

      startingPoint = settings.startingPoint;
      POIHeight = settings.POIHeight;
      adjustedScrollTop = scrollTop - startingPoint;
      POIIndex = adjustedScrollTop / POIHeight;
      if (POIIndex < 0) {
        return 0;
      } else {
        return POIIndex;
      }
    }
  };

}).call(this);
