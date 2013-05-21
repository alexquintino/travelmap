window.TRIP = {
  scrolling :
    settings:
      startingPoint : 0
      POIHeight : 0

  initDom : (element) ->
    windowHeight = $(window).height()
    $("#start").attr("data-0","opacity:1")
    $("#start").attr("data-"+windowHeight,"opacity:0")

    labels = ["SAN JOSÉ","LA FORTUNA", "TAMARINDO", "ISLA DE OMETEPE"]
    count = 1

    _.each labels, (label) ->
      startHeight = count * windowHeight
      endHeight = startHeight + windowHeight
      heights = {startHeight:startHeight, endHeight:endHeight}

      innerDiv = _.template("<div class=\"poi-label\"><h1><%= label %></h1></div>",{label: label})

      outerDivData = _.template("data-<%=startHeight%>=\"opacity:0\" data-<%= endHeight %>=\"opacity:1\"",heights)
      html = _.template("<div class=\"poi\" <%=outerDivData%> ><%= innerDiv %></div>",{innerDiv: innerDiv, outerDivData:outerDivData})
      element.append(html);
      count += 1

}
