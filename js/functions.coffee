window.TRIP = {
  scrolling :
    settings:
      startingPoint : 0
      POIHeight : 0

  initDom : (element) ->
    labels = ["SAN JOSÉ","LA FORTUNA", "TAMARINDO", "ISLA DE OMETEPE"]
    _.each labels, (label) ->
      html = _.template("<div class=\"poi-label\" data-bottom-top=\"opacity:0\" data-100-top=\"opacity:1\"><h1><%= label %></h1></div>",{label: label})
      element.append(html);

}
