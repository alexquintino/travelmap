describe "POIS", ->

  describe "calculateCurrentPOIIndex", ->
    scrollSettings = {
      startingPoint : 1200
      POIHeight : 500
    }


    it 'should return zero or no index', ->
      expect(TRIP.pois.calculateCurrentPOIIndex(300,scrollSettings)).toEqual(0)
      expect(TRIP.pois.calculateCurrentPOIIndex(1199,scrollSettings)).toEqual(0)

    it 'should return 1', ->
      expect(Math.ceil(TRIP.pois.calculateCurrentPOIIndex(1201,scrollSettings))).toEqual(1)