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
    console.log typeof _callback
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
 