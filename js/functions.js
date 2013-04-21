(function() {
  window.TRIP = {
    initDom: function(element) {
      var labels;

      labels = ["SAN JOSÉ", "LA FORTUNA", "TAMARINDO", "ISLA DE OMETEPE"];
      return _.each(labels, function(label) {
        var html;

        html = _.template("<div class=\"poi-label\" data-bottom-top=\"left:-50%\" data-100-top=\"left:0%\"><h1><%= label %></h1></div>", {
          label: label
        });
        return element.append(html);
      });
    },
    initMap: function(mapElem) {
      var options, overlay;

      options = {
        center: new google.maps.LatLng(POIS.costaRica.sanJose.lat, POIS.costaRica.sanJose.lon),
        zoom: 10,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        disableDoubleClickZoom: true,
        keyboardShortcuts: false,
        disableDefaultUI: true,
        draggable: false,
        scrollwheel: false
      };
      TRIP.map = new google.maps.Map(document.getElementById("map_canvas"), options);
      overlay = new google.maps.OverlayView();
      overlay.onAdd = function() {
        var layer, mapOverlay, svg;

        layer = d3.select(this.getPanes().overlayLayer).append("div").attr("class", "SvgOverlay");
        svg = layer.append("svg").attr("width", mapElem.width()).attr("height", mapElem.height());
        mapOverlay = svg.append("g").attr("id", "mapOverlay");
        return overlay.draw = function() {
          var markerOverlay, overlayProjection, path;

          markerOverlay = this;
          overlayProjection = markerOverlay.getProjection();
          TRIP.googleMapProjection = function(coordinates) {
            var googleCoordinates, pixelCoordinates;

            googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0]);
            pixelCoordinates = overlayProjection.fromLatLngToDivPixel(googleCoordinates);
            return [pixelCoordinates.x, pixelCoordinates.y];
          };
          path = d3.geo.path().projection(TRIP.googleMapProjection);
          return TRIP.initPaths();
        };
      };
      return overlay.setMap(TRIP.map);
    },
    drawPath: function(from, to) {
      var data, fromCoord, line, toCoord;

      fromCoord = TRIP.googleMapProjection([from.lon, from.lat]);
      toCoord = TRIP.googleMapProjection([to.lon, to.lat]);
      data = [
        {
          x: fromCoord[0],
          y: fromCoord[1]
        }, {
          x: toCoord[0],
          y: toCoord[1]
        }
      ];
      line = d3.svg.line().x(function(d) {
        return d.x;
      }).y(function(d) {
        return d.y;
      }).interpolate("linear");
      return d3.select('#mapOverlay').append('path').attr('d', line(data)).attr('stroke', 'blue').attr('stroke-width', 2);
    },
    updateMapPosition: function(currentTop) {
      return console.log(currentTop);
    }
  };

}).call(this);
