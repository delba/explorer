@geoLocation = null
@map = null

searchVenues = (category) =>
  $.ajax
    type: 'GET'
    url: '/search'
    data:
      categoryId: category.id
      ll: "#{@geoLocation.lat}, #{@geoLocation.lng}"
    dataType: 'json'
    success: (json) ->
      category.data = json
      category.markers = L.geoJson
        type: 'FeatureCollection'
        features: for venue in json.venues
          type: 'Feature'
          geometry:
            type: 'Point'
            coordinates: [venue.location.lng, venue.location.lat]
          properties: venue

      showMarkers category
      showVenues category

showMap = (category) ->
  category.map.setZIndex 1

  for other in category.others()
    other.map.setZIndex -1

showMarkers = (category) =>
  @map.addLayer category.markers

showVenues = (category) =>
  venues = for venue, index in category.data.venues
    parent = "##{category.name}_venues"
    id = "#{category.name}_#{index}"

    """
    <div class="list-group-item panel">
      <a data-toggle="collapse" data-parent="#{parent}" data-target="##{id}">
        #{venue.name}
      </a>
      <div id="#{id}" class="collapse"></div>
    </div>
    """

  $("##{category.name}_venues")
    .append venues

showCategory = (e) =>
  name = $(e.target).data('category')

  category = Category.findByName name

  for other in category.others() when other.markers
    @map.removeLayer other.markers

  showMap category

  if @geoLocation
    if category.data
      showMarkers category
    else
      searchVenues category

locationFound = (e) =>
  @geoLocation = e.latlng

  name = $('.nav li.active a').data('category')

  category = Category.findByName name

  searchVenues category

$(document).on 'show.bs.tab', 'a[data-toggle="pill"]', showCategory

#ready = =>
@Map =
  init: (geoLocation) ->
    geoLocation = JSON.parse(geoLocation)

    console.log geoLocation.latitude

    @map = L.map('map-container',
      zoomControl: false
      attributionControl: false
    ).setView([geoLocation.latitude, geoLocation.longitude], 18)

    @map.on 'locationfound', locationFound

    # Create data

    new Category
      name: 'coffee'
      id: '4bf58dd8d48988d1e0931735'
      map: 'delba.h4dco5m4'
      data: null
      markers: null

    new Category
      name: 'bourbon'
      id: '4bf58dd8d48988d122941735'
      map: 'delba.h4c3hgpj'
      data: null
      markers: null

    new Category
      name: 'club'
      id: '4bf58dd8d48988d11f941735'
      map: 'delba.h4dd4chj'
      data: null
      markers: null

    coffee = Category.findByName 'coffee'
    showMap coffee

    for category in Category.all
      @map.addLayer category.map

    L.control.locate().addTo @map

#$(document).on 'ready', ready

