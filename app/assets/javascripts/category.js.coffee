class @Category
  @all = []

  @findByName = (name) ->
    for category in Category.all
      if category.name is name
        return category

  constructor: (options) ->
    @name = options.name
    @id   = options.id
    @map  = L.mapbox.tileLayer options.map,
      detectRetina: true
    @data = null
    @markers = null
    Category.all.push this

  others: ->
    for category in Category.all when category.id isnt @id
      category
