$ ->

  data =
    'name': 'Название магазина'
    'categories': [
        {
          'id': 1 
          'title': 'Категория 1'
          'img': ''
        }
        {
          'id': 2
          'title': 'Категория 2'
          'img': ''
        }
        {
          'id': 3
          'title': 'Категория 3'
          'img': ''
        }
        {
          'id': 4
          'title': 'Категория 4'
          'img': ''
        }
        {
          'id': 5
          'title': 'Категория 5'
          'img': ''
        }
    ]
    'products': [
      { 
        'id': 1
        'title': 'Товар 1'
        'price': 100
        'img': ''
        'categoryID': 1
      }
      {  
        'id': 2
        'title': 'Товар 2'
        'price': 400
        'img': ''
        'categoryID': 1
      }
    ]

  class Categories
    items = {}
    constructor : (_items) ->
      if _items and typeof _items is 'object'
        items = _items

    getById: (_id) ->
      id = (parseInt _id) || 0
      item = undefined
      $.each items, ->
        if this.id is id
          item = this
          false
      item

    getAll: ->
      items


  class Products
    items = {}
    constructor : (_items) ->
      if _items and typeof _items is 'object'
        items = _items
    getById: (_id) ->
      id = (parseInt _id) || 0
      item = undefined
      $.each items, ->
        if this.id is id
          item = this
          false
      item

    getAll: ->
      items

  class Cart
    items = {}
    sum = 0
    constructor : () ->
      _arr = localStorage.getItem('cart.items')

      if _arr != '' and _arr != null
        $.each _arr.split(';'), () ->
          arr = this.split ':'
          items[arr[0]] = arr[1]

    getItems: ->
      items

    getSum: ->
      sum

    add: (_id, _callback) ->
      if items[_id] != undefined
        items[_id] = (parseInt items[_id]) + 1
      else 
        items[_id] = 1

      this.update(_callback)

    remove: (_id, _callback) ->
      delete items[_id]
      this.update(_callback)

    clean: (_callback) ->
      items = {}
      this.update(_callback)

    update: (_callback) ->
      str = ''
      sum = 0

      $.each items, (_key, _value) ->
        if str == ''
          str = "#{_key}:#{_value}"
        else
          str = "#{str};#{_key}:#{_value}"

        item = app.products.getById _key

        sum = sum + ( (parseInt item.price) * (parseInt _value) )

      localStorage.setItem 'cart.items', str 

      if _callback and typeof _callback is 'function'
        _callback()

  class App

    сart: new Cart 
    products: new Products data.products
    categories: new Categories data.categories

    render: (_selector, _template, _data, _callback) ->
      template = Handlebars.compile $(_template).html()
      $(_selector).html template(data)

      if _callback and typeof _callback is 'function'
        _callback()
      return

  app = new App

  app.render '#categories', '#category-template', data, ->
    app.render '#products', '#product-template', data, ->
      $first = $ '.category:first'
      categoryID = $first.data 'id'
      $first.addClass 'category_active'
      $('.product').removeClass 'product_active'
      $items = $ "[data-category-id=#{categoryID}]"
      $items.addClass 'product_active'

      app.сart.update ->
        if app.сart.getSum() == 0
          $('.cart').text "Пусто"
        else 
          $('.cart').text "#{app.сart.getSum()} руб."

      $('body').on 'click', '.cart__add', ->
        $this = $ this
        id = $this.data 'id'
        app.сart.add id, ->
          if app.сart.getSum() == 0
            $('.cart').text "Пусто"
          else 
            $('.cart').text "#{app.сart.getSum()} руб."

      $('body').on 'click', '.category', ->
        $this = $ this
        categoryID = $this.data 'id'

        $('.category').removeClass 'category_active'
        $this.addClass 'category_active'

        $('.product').removeClass 'product_active'
        $items = $ "[data-category-id=#{categoryID}]"
        $items.addClass 'product_active'

      $('body').on 'click', '.cart', ->
        app.сart.clean ->
          $('.cart').text "Пусто"