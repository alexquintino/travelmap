window.TRIP = {
  scrolling :
    settings:
      startingPoint : 0
      POIHeight : 0

  initDom : (element,pois_list) ->
    windowHeight = $(window).height()
    $("#start").attr("data-0","opacity:1")
    $("#start").attr("data-"+windowHeight,"opacity:0")

    count = 1

    _.each pois_list, (poi) ->
      label = poi.name
      startHeight = count * windowHeight
      endHeight = startHeight + windowHeight
      disappearHeight = endHeight + 200
      heights = {startHeight:startHeight, endHeight:endHeight, disappearHeight: disappearHeight}

      innerDiv = _.template("<div class=\"poi-label\"><h1><%= label %></h1></div>",{label: label})

      outerDivData = _.template("data-<%=startHeight%>=\"opacity:0\" data-<%= endHeight %>=\"opacity:1\" data-<%= disappearHeight %>=\"opacity:0\"",heights)
      html = _.template("<div class=\"poi\" <%=outerDivData%> ><%= innerDiv %></div>",{innerDiv: innerDiv, outerDivData:outerDivData})
      element.append(html);
      count += 1

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
