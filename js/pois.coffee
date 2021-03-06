window.TRIP.pois = {
  calculateCurrentPOIIndex: (scrollTop, settings) ->
    startingPoint = settings.startingPoint
    POIHeight = settings.POIHeight

    adjustedScrollTop = scrollTop - startingPoint
    POIIndex = adjustedScrollTop / POIHeight
    if POIIndex < 0 then 0 else POIIndex

  firstPOI: () ->
    TRIP.pois.list[0]

  currentPOI : (POIIndex,POIList) ->
    currentPOIIndexFloored = Math.floor(POIIndex)
    if currentPOIIndexFloored >= POIList.length
      _.last(POIList)
    else
      POIList[currentPOIIndexFloored]

  nextPOI : (POIIndex,POIList) ->
    currentPOIIndexFloored = Math.floor(POIIndex)
    if currentPOIIndexFloored + 1 >= POIList.length
      _.last(POIList)
    else
      POIList[currentPOIIndexFloored + 1]

  percentageFromCurrentToNextPOI : (POIIndex) ->
    POIIndexFloored = Math.floor(POIIndex)
    if POIIndex == POIIndexFloored
      0
    else
      POIIndex - POIIndexFloored

  loadGeoJson: () ->
    $.getJSON("/pois.geo.json", (data) ->
      TRIP.pois.geoJson = data
    )
  loadJson: () ->
    $.getJSON("/pois.json", (data) ->
      TRIP.pois.list = data
    )
}