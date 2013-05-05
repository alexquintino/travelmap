describe 'Map', ->
  Frankfurt = {lat:50.037122, lon:8.560538}
  London = {lat:51.472, lon:-0.451}
  Miami = {lat:25.795, lon:-80.284}
  POIList = [Frankfurt,London,Miami]

  describe 'currentPOI', ->
    it 'should return the first POI', ->
      expect(TRIP.map.currentPOI(0.2,POIList)).toBe(Frankfurt)
      expect(TRIP.map.currentPOI(0.67,POIList)).toBe(Frankfurt)
      expect(TRIP.map.currentPOI(0.99,POIList)).toBe(Frankfurt)

    it 'should return the second POI', ->
      expect(TRIP.map.currentPOI(1.2,POIList)).toBe(London)
      expect(TRIP.map.currentPOI(1.67,POIList)).toBe(London)
      expect(TRIP.map.currentPOI(1.99,POIList)).toBe(London)

    it 'should return last POI if the POI Index is over the size of the list', ->
      expect(TRIP.map.currentPOI(66,POIList)).toBe(Miami)
      expect(TRIP.map.currentPOI(3,POIList)).toBe(Miami)
      expect(TRIP.map.currentPOI(4,POIList)).toBe(Miami)

  describe 'nextPOI', ->
    it 'should return the second POI', ->
      expect(TRIP.map.nextPOI(0.2,POIList)).toBe(London)
      expect(TRIP.map.nextPOI(0.67,POIList)).toBe(London)
      expect(TRIP.map.nextPOI(0.99,POIList)).toBe(London)

    it 'should return the second POI', ->
      expect(TRIP.map.nextPOI(1.2,POIList)).toBe(Miami)
      expect(TRIP.map.nextPOI(1.67,POIList)).toBe(Miami)
      expect(TRIP.map.nextPOI(1.99,POIList)).toBe(Miami)

    it 'should return last POI if the POI Index is over the size of the list', ->
      expect(TRIP.map.currentPOI(66,POIList)).toBe(Miami)
      expect(TRIP.map.currentPOI(3,POIList)).toBe(Miami)
      expect(TRIP.map.currentPOI(4,POIList)).toBe(Miami)

  describe 'percentageFromCurrentToNextPOI', ->
    it 'should return 0.25 for (0.25)', ->
      expect(TRIP.map.percentageFromCurrentToNextPOI(0.25)).toBe(0.25)
    it 'should return 0.50 for (1.50)', ->
      expect(TRIP.map.percentageFromCurrentToNextPOI(1.50)).toBe(0.50)
    it 'should return 0.75 for (2.75)', ->
      expect(TRIP.map.percentageFromCurrentToNextPOI(2.75)).toBe(0.75)
    it 'should return 0 for (3)', ->
      expect(TRIP.map.percentageFromCurrentToNextPOI(3)).toBe(0)

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
    it 'should return 7 for currentPOIIndex: 0.5', ->
      expect(TRIP.map.calculateNextZoomLevel(0.5,initialZoom,finalZoom)).toBe(7)
    it 'should return 10 for currentPOIIndex: 0.9', ->
      expect(TRIP.map.calculateNextZoomLevel(0.9,initialZoom,finalZoom)).toBe(10)