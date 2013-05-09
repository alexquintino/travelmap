describe "POIS", ->
  Frankfurt = {lat:50.037122, lon:8.560538}
  London = {lat:51.472, lon:-0.451}
  Miami = {lat:25.795, lon:-80.284}
  POIList = [Frankfurt,London,Miami]

  describe "calculateCurrentPOIIndex", ->
    scrollSettings = {
      startingPoint : 1200
      POIHeight : 500
    }


    it 'should return zero or no index', ->
      expect(TRIP.pois.calculateCurrentPOIIndex(300,scrollSettings)).toEqual(0)
      expect(TRIP.pois.calculateCurrentPOIIndex(1199,scrollSettings)).toEqual(0)

    it 'should return between 0 and 1', ->
      expect(Math.ceil(TRIP.pois.calculateCurrentPOIIndex(1201,scrollSettings))).toEqual(1)
      expect(TRIP.pois.calculateCurrentPOIIndex(1450,scrollSettings)).toEqual(0.5)
      expect(TRIP.pois.calculateCurrentPOIIndex(1700,scrollSettings)).toEqual(1)

    it 'should return between 1 and 2', ->
      expect(Math.ceil(TRIP.pois.calculateCurrentPOIIndex(1701,scrollSettings))).toEqual(2)
      expect(TRIP.pois.calculateCurrentPOIIndex(1950,scrollSettings)).toEqual(1.5)
      expect(TRIP.pois.calculateCurrentPOIIndex(2200,scrollSettings)).toEqual(2)

  describe 'currentPOI', ->
    it 'should return the first POI', ->
      expect(TRIP.pois.currentPOI(0.2,POIList)).toBe(Frankfurt)
      expect(TRIP.pois.currentPOI(0.67,POIList)).toBe(Frankfurt)
      expect(TRIP.pois.currentPOI(0.99,POIList)).toBe(Frankfurt)

    it 'should return the second POI', ->
      expect(TRIP.pois.currentPOI(1.2,POIList)).toBe(London)
      expect(TRIP.pois.currentPOI(1.67,POIList)).toBe(London)
      expect(TRIP.pois.currentPOI(1.99,POIList)).toBe(London)

    it 'should return last POI if the POI Index is over the size of the list', ->
      expect(TRIP.pois.currentPOI(66,POIList)).toBe(Miami)
      expect(TRIP.pois.currentPOI(3,POIList)).toBe(Miami)
      expect(TRIP.pois.currentPOI(4,POIList)).toBe(Miami)

  describe 'nextPOI', ->
    it 'should return the second POI', ->
      expect(TRIP.pois.nextPOI(0.2,POIList)).toBe(London)
      expect(TRIP.pois.nextPOI(0.67,POIList)).toBe(London)
      expect(TRIP.pois.nextPOI(0.99,POIList)).toBe(London)

    it 'should return the second POI', ->
      expect(TRIP.pois.nextPOI(1.2,POIList)).toBe(Miami)
      expect(TRIP.pois.nextPOI(1.67,POIList)).toBe(Miami)
      expect(TRIP.pois.nextPOI(1.99,POIList)).toBe(Miami)

    it 'should return last POI if the POI Index is over the size of the list', ->
      expect(TRIP.pois.currentPOI(66,POIList)).toBe(Miami)
      expect(TRIP.pois.currentPOI(3,POIList)).toBe(Miami)
      expect(TRIP.pois.currentPOI(4,POIList)).toBe(Miami)

  describe 'percentageFromCurrentToNextPOI', ->
    it 'should return 0.25 for (0.25)', ->
      expect(TRIP.pois.percentageFromCurrentToNextPOI(0.25)).toBe(0.25)
    it 'should return 0.50 for (1.50)', ->
      expect(TRIP.pois.percentageFromCurrentToNextPOI(1.50)).toBe(0.50)
    it 'should return 0.75 for (2.75)', ->
      expect(TRIP.pois.percentageFromCurrentToNextPOI(2.75)).toBe(0.75)
    it 'should return 0 for (3)', ->
      expect(TRIP.pois.percentageFromCurrentToNextPOI(3)).toBe(0)