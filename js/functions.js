TRIP = {
	initDom : function(element) {
	
		var labels = ["SAN JOSÉ","LA FORTUNA", "TAMARINDO", "ISLA DE OMETEPE"];
	
		_.each(labels, function(label) {
			html = _.template("<div class=\"poi-label\"><h1 data--100-bottom-top=\"opacity:1\" data-bottom-bottom=\"opacity:0\" ><%= label %></h1></div>",{label: label});
			element.prepend(html);	
		});
	},
	initMap : function(mapElem,callback) {
		var options = {
			center : new google.maps.LatLng(POIS.costaRica.sanJose.lat,POIS.costaRica.sanJose.lon),
			zoom: 10,
			mapTypeId: google.maps.MapTypeId.ROADMAP,
			disableDoubleClickZoom: true,
			keyboardShortcuts: false,
			disableDefaultUI: true,
			draggable: false,
			scrollwheel: false,
		};
		
		TRIP.map = new google.maps.Map(document.getElementById("map_canvas"),options);
		var overlay = new google.maps.OverlayView();
		overlay.onAdd = function() {
			var layer = d3.select(this.getPanes().overlayLayer).append("div").attr("class", "SvgOverlay");
			
			var svg = layer.append("svg").attr("width", mapElem.width()).attr("height", mapElem.height())
			mapOverlay = svg.append("g").attr("id", "mapOverlay");
	
			overlay.draw = function() {
				var markerOverlay = this;
				var overlayProjection = markerOverlay.getProjection();
	
				// Turn the overlay projection into a d3 projection
				TRIP.googleMapProjection = function(coordinates) {
					var googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0]);
					var pixelCoordinates = overlayProjection.fromLatLngToDivPixel(googleCoordinates);
					return [pixelCoordinates.x, pixelCoordinates.y];
				}
				path = d3.geo.path().projection(TRIP.googleMapProjection);
				TRIP.initPaths();
				
			};
		};
		overlay.setMap(TRIP.map);
	},
	drawPath : function(from,to) {
		var fromCoord = TRIP.googleMapProjection([from.lon,from.lat]);
		var toCoord = TRIP.googleMapProjection([to.lon,to.lat]);
		
		data = [{x: fromCoord[0], y:fromCoord[1]},
				{x: toCoord[0], y:toCoord[1]}];
		
		var line = d3.svg.line()
	    	.x(function(d) { return d.x; })
	    	.y(function(d) { return d.y; })
	    	.interpolate("linear");
	    
	    d3.select('#mapOverlay').append('path')
	    	.attr('d',line(data))
	    	.attr('stroke','blue')
	    	.attr('stroke-width',2);
	},
	updateMapPosition : function(currentTop) {
		windowHeight = $(window).height();
		poiIndex = Math.floor((currentTop+windowHeight) / windowHeight);
		console.log(poiIndex);
	}
};
