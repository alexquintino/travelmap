window.TRIP = {
  scrolling :
    settings:
      startingPoint : 0
      POIHeight : 0

  initDom : (element,pois_list) ->
    windowHeight = $(window).height()
    $("#start").attr("data-0","opacity:1")
    $("#start").attr("data-"+windowHeight,"opacity:0")
    template = Mustache.compile $("#poi-template").html()

    _.each pois_list, (poi,index) ->
      label = poi.name
      heights = TRIP.calculateHeights(windowHeight,index)
      templateData = { heights: heights, label: label}
      element.append(template(templateData));

  calculateHeights : (windowHeight,index) ->
    start = @startHeight(windowHeight,index)
    end = @endHeight(windowHeight,start)
    disappear = @disappearHeight(end)
    {start: start, end: end, disappear: disappear}    

  startHeight : (windowHeight,index) ->
    index * windowHeight

  endHeight : (windowHeight, startHeight) ->
    startHeight + windowHeight

  disappearHeight : (endHeight) ->
    endHeight + 200

  initSkrollr : () ->
    TRIP.scrolling.skrollr = skrollr.init {
      render : @scrollCallback,
      forceHeight : true,
      smoothScrolling: true
    }

  _scrollCallback : (props) ->
    if TRIP.map.isReady()
      currentPOIIndex = TRIP.pois.calculateCurrentPOIIndex(props.curTop,TRIP.scrolling.settings)
      TRIP.map.updatePosition(currentPOIIndex,TRIP.pois.list)
  }
