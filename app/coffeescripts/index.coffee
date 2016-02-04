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
        'img': ''
        'categoryID': 1
      }
      {  
        'id': 2
        'title': 'Товар 2'
        'img': ''
        'categoryID': 2
      }
      { 
        'id': 1
        'title': 'Товар 1'
        'img': ''
        'categoryID': 1
      }
      {  
        'id': 2
        'title': 'Товар 2'
        'img': ''
        'categoryID': 2
      }
      { 
        'id': 1
        'title': 'Товар 1'
        'img': ''
        'categoryID': 1
      }
      {  
        'id': 2
        'title': 'Товар 2'
        'img': ''
        'categoryID': 2
      }
      { 
        'id': 1
        'title': 'Товар 1'
        'img': ''
        'categoryID': 5
      }
      {  
        'id': 2
        'title': 'Товар 2'
        'img': ''
        'categoryID': 2
      }
      {  
        'id': 2
        'title': 'Товар 2'
        'img': ''
        'categoryID': 4
      }
      { 
        'id': 1
        'title': 'Товар 1'
        'img': ''
        'categoryID': 1
      }
      {  
        'id': 2
        'title': 'Товар 2'
        'img': ''
        'categoryID': 4
      }
      {  
        'id': 2
        'title': 'Товар 2'
        'img': ''
        'categoryID': 4
      }
      { 
        'id': 1
        'title': 'Товар 1'
        'img': ''
        'categoryID': 4
      }
      {  
        'id': 4
        'title': 'Товар 2'
        'img': ''
        'categoryID': 4
      }
      {  
        'id': 3
        'title': 'Товар 2'
        'img': ''
        'categoryID': 3
      }
      { 
        'id': 3
        'title': 'Товар 1'
        'img': ''
        'categoryID': 3
      }
      {  
        'id': 3
        'title': 'Товар 2'
        'img': ''
        'categoryID': 3
      }
    ]

  rander = (_id, _template, _data, _callback) ->
    template = Handlebars.compile $(_template).html()
    $(_id).html template(data)
    if _callback and typeof _callback == 'function'
      _callback()
    return


  rander '#categories', '#category-template', data, ->
    rander '#products', '#product-template', data, ->
      $first = $ '.category:first'
      categoryID = $first.data 'id'
      $first.addClass 'category_active'
      $('.product').removeClass 'product_active'
      $items = $ "[data-category-id=#{categoryID}]"
      $items.addClass 'product_active'

      $('body').on 'click', '.category', ->
        $this = $ this
        categoryID = $this.data 'id'

        $('.category').removeClass 'category_active'
        $this.addClass 'category_active'

        $('.product').removeClass 'product_active'
        $items = $ "[data-category-id=#{categoryID}]"
        $items.addClass 'product_active'


  $cart = $ '.cart'

  getProductById = (_id) ->
    id = (parseInt _id) || 0

    product = {}

    $.each data.products, ->
      console.log this.id
      if this.id is id
        product = this
        false

    return product

  console.log getProductById(1)

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
    items = ''
    sum = 0
    constructor : () ->
      _arr = localStorage.getItem('cart.items').split(';')
      $.echo _arr, () ->
        arr = this.split ':'

    add: (_item) ->
      items.push(_item)
      this.update()

    remove: (_id) ->
      this.update()
    update: () ->
      localStorage.setItem 'cart.items', items 

  class App
    render: (_selector, _template, _data, _callback) ->
      template = Handlebars.compile $(_template).html()
      $(_selector).html template(data)

      if _callback and typeof _callback is 'function'
        _callback()
      return