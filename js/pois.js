(function() {
  window.TRIP.pois = {
    calculateCurrentPOIIndex: function(scrollTop, currentPOIIndex, startingPoint, spaceBetweenPOI, POIHeight) {
      var acumulatedPOIHeight, adjustedScrollTop;

      adjustedScrollTop = scrollTop - startingPoint;
      acumulatedPOIHeight = POIHeight * currentPOIIndex;
      return adjustedScrollTop / (spaceBetweenPOI + acumulatedPOIHeight);
    }
  };

}).call(this);
