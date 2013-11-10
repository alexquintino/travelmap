window.TRIP.functions = {

  initDom : (element,pois_list) ->
    $("#start").attr("data-0","opacity:1")
    $("#start").attr("data-"+$(window).height(),"opacity:0")
    template = Mustache.compile $("#poi-template").html()

    _.each pois_list, (poi,index) ->
      label = poi.name
      heights = TRIP.functions.calculateHeights(index)
      templateData = { heights: heights, label: label}
      element.append(template(templateData));

  calculateHeights : (index) ->
    start = @startHeight(index)
    end = @endHeight(start)
    disappear = @disappearHeight(end)
    {start: start, end: end, disappear: disappear}    

  startHeight : (index) ->
    index * TRIP._vars.scrolling.POIHeight

  endHeight : (startHeight) ->
    startHeight + TRIP._vars.scrolling.POIHeight

  disappearHeight : (endHeight) ->
    endHeight + 200

  initSkrollr : () ->
    TRIP._skrollr = skrollr.init {
      render : @scrollCallback,
      forceHeight : true,
      smoothScrolling: true
    }

  scrollCallback : (props) ->
    if TRIP.map.isReady()
      currentPOIIndex = TRIP.pois.calculateCurrentPOIIndex(props.curTop,TRIP._vars.scrolling)
      TRIP.map.updatePosition(currentPOIIndex,TRIP.pois.list)
}

