window.TRIP.pois = {
  calculateCurrentPOIIndex: (scrollTop, settings) ->
    startingPoint = settings.startingPoint
    POIHeight = settings.POIHeight

    adjustedScrollTop = scrollTop - startingPoint
    POIIndex = adjustedScrollTop / POIHeight
    if POIIndex < -1 then -1 else POIIndex
}