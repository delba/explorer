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
  venues = for venue in category.data.venues
    "<a href='#' class='list-group-item'>#{venue.name}</a>"

  $("##{category.name} .list-group")
    .find('.searching').hide().end()
    .append venues

showCategory = (e) =>
  name = e.target.text.toLowerCase()

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

  $('.locate-me').hide()
  $('.searching').show()

  name = $('.nav li.active').text().toLowerCase()

  category = Category.findByName name

  searchVenues category

locateMe = (e) =>
  e.preventDefault()
  @map.locate()

$(document).on 'show.bs.tab', 'a[data-toggle="pill"]', showCategory
$(document).on 'click', 'a.locate-me, p.locate-me a', locateMe

ready = =>
  # Set up the map

  @map = L.map('map-container',
    zoomControl: false
    attributionControl: false
  ).setView([37.779, -122.418], 13)

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

$(document).on 'ready', ready
