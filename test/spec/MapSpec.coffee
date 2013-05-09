describe 'Map', ->
  Frankfurt = {lat:50.037122, lon:8.560538}
  London = {lat:51.472, lon:-0.451}
  Miami = {lat:25.795, lon:-80.284}
  POIList = [Frankfurt,London,Miami]

  describe 'calculateNextCoordinates', ->
    describe "basic case with cur:[10,10] and next:[20,20]", ->
      currentPOI = {lat: 10, lon:10}
      nextPOI = {lat: 20, lon:20}
      it 'should return lat:12.5, lon:12.5 for a 0.25 percentage', ->
        expect(TRIP.map.calculateNextCoordinates(0.25,currentPOI,nextPOI).lat).toBe(12.5)
        expect(TRIP.map.calculateNextCoordinates(0.25,currentPOI,nextPOI).lon).toBe(12.5)
      it 'should return lat:20, lon:20 for a 1 percentage', ->
              expect(TRIP.map.calculateNextCoordinates(1,currentPOI,nextPOI).lat).toBe(20)
              expect(TRIP.map.calculateNextCoordinates(1,currentPOI,nextPOI).lon).toBe(20)
    describe "cur:[-10,-10] and next:[20,20]", ->
      currentPOI = {lat:-10,lon:-10}
      nextPOI = {lat: 20,lon:20}
      it 'should return [5,5] for a 0.5%', ->
        expect(TRIP.map.calculateNextCoordinates(0.5,currentPOI,nextPOI).lat).toBe(5)
        expect(TRIP.map.calculateNextCoordinates(0.5,currentPOI,nextPOI).lon).toBe(5)

  describe 'calculateNextZoomLevel', ->
    initialZoom = 4
    finalZoom = 10
    it 'should return 4 for currentPOIIndex: 0', ->
      expect(TRIP.map.calculateNextZoomLevel(0,initialZoom,finalZoom)).toBe(4)
    it 'should return 7 for currentPOIIndex: 0.5', ->
      expect(TRIP.map.calculateNextZoomLevel(0.5,initialZoom,finalZoom)).toBe(7)
    it 'should return 10 for currentPOIIndex: 0.9', ->
      expect(TRIP.map.calculateNextZoomLevel(0.9,initialZoom,finalZoom)).toBe(10)

  describe 'throttledUpdatePosition', ->
    beforeEach ->
      spyOn(TRIP.map,"calculateNextZoomLevel").andCallThrough()
      spyOn(TRIP.map,"setZoom")
      spyOn(TRIP.map,"panTo")
      spyOn(TRIP.pois,"currentPOI").andReturn(POIList[0])
      spyOn(TRIP.pois,"nextPOI").andReturn(POIList[1])
      spyOn(TRIP.pois,"percentageFromCurrentToNextPOI").andReturn(0.5)

    it 'should set the zoom for currentIndex 0', ->
      TRIP.map.throttledUpdatePosition(0)
      expect(TRIP.map.calculateNextZoomLevel).toHaveBeenCalledWith(0,TRIP.map.minZoomLevel,TRIP.map.maxZoomLevel)
      expect(TRIP.map.setZoom).toHaveBeenCalled()
    it 'should set the zoom for currentIndex 0.5', ->
      TRIP.map.throttledUpdatePosition(0.5)
      expect(TRIP.map.calculateNextZoomLevel).toHaveBeenCalledWith(0.5,TRIP.map.minZoomLevel,TRIP.map.maxZoomLevel)
      expect(TRIP.map.setZoom).toHaveBeenCalled()
    it 'should call currentPOI and nextPOI for currentIndex 1', ->
      TRIP.map.throttledUpdatePosition(1)
      expect(TRIP.pois.currentPOI).toHaveBeenCalledWith(0,TRIP.POISOrder)
      expect(TRIP.pois.nextPOI).toHaveBeenCalledWith(0,TRIP.POISOrder)
      expect(TRIP.pois.percentageFromCurrentToNextPOI).toHaveBeenCalledWith(0,TRIP.POISOrder)
      expect(TRIP.map.panTo).toHaveBeenCalled()
