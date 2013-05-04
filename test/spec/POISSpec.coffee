describe "POIS", ->

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
