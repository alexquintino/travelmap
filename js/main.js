
TRIP.POISOrder = [
	POIS.costaRica.sanJose,
	POIS.costaRica.laFortuna,
	POIS.costaRica.tamarindo,
	POIS.costaRica.PenasBlancas];
	
TRIP.numberOfPOIS = TRIP.POISOrder.length;

var scrollCallback = function(props) {
	TRIP.updateMapPosition(props.curTop);	
}



var drawPOI = function(poi) {
		var coordinates = googleMapProjection([poi.lon,poi.lat]);
	    d3.select("#mapOverlay").append('svg:circle')
	        .attr('cx', coordinates[0])
	        .attr('cy', coordinates[1])
	        .attr('r', 5)
	        .attr('class',"poi");
};

TRIP.initPaths = function() {
	if(($("#mapOverlay path")).size() == 0) {
		TRIP.drawPath(POIS.costaRica.sanJose,POIS.costaRica.laFortuna);
		TRIP.drawPath(POIS.costaRica.laFortuna,POIS.costaRica.tamarindo);
	}
};

var drawOverlay = function() {
	
};




TRIP.initDom($("body"));
TRIP.initMap($("#map_canvas"));


$(function() {
    $(".poi-label").css("margin-top",$(window).height())

//    var s = skrollr.init({
//		render : scrollCallback,
//		forceHeight : true,
//        smoothScrolling: true
//	});

});
