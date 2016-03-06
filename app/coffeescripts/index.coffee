"use strict"

createBodyScroll = ->
  $('body').css 'overflow-y','auto'
  $('body').niceScroll
    cursorborder: '0'
    cursorcolor: '#9d9d9d'
    scrollspeed: 100
    mousescrollstep: 25
    cursorwidth: '4px'
    cursorborderradius: '0px'
    zindex: 5000
  $('body').getNiceScroll().resize()

removeBodyScroll = ->
  $('body').getNiceScroll().remove()
  $('body').css 'overflow-y','hidden'

API_URL = 'http://aleksandr-sazhin.myjino.ru'

class Collection
  constructor : (_items) ->
    @items = []
    if _items and typeof _items is 'object'
      @items = _items[..]

  getById: (_id) ->
    id = (parseInt _id) || 0
    item = undefined
    $.each @items, ->
      if +@.id is id
        item = @
        false
    
    obj = {}

    for key of item
      obj[key] = item[key]
    obj

  getBy: (_key, _value)->
    key = _key || 'id'
    value = _value || 0

    obj = []
    $.each @items, ->
      if +@[key] is value
        obj.push @
        
    obj

class App
  constructor : (_data) ->

    self = this
    @products = new Collection _data.products
    @categories = new Collection _data.categories

    @cart = {
      items: {}
      sum: 0
      size: ->
        size = 0
        $.each @items, (_key, _value) ->
          size++
        size

      run: ->
        arr = localStorage.getItem('cart.items')
        if arr != '' and arr != null
          items = {}

          $.each arr.split(';'), () ->
            arr = @.split ':'
            item = self.products.getById arr[0]
            if item.id
              items[arr[0]] = parseInt arr[1]

          @items = items

        @update()

      add: (_id, _callback) ->
        if @items[_id] != undefined
          @items[_id] = parseInt @items[_id] + 1
        else 
          @items[_id] = 1

      remove: (_id, _callback) ->
        if (parseInt @items[_id]) != 1
          @items[_id] = parseInt @items[_id] - 1
        else 
          delete @items[_id]

      clean: (_id, _callback) ->
        if _id != ''
          delete @items[_id]
        else 
          @items = {}

      render: ->
        items = []
        $.each @items, (_key, _value) ->
          item = self.products.getById _key
          item.quantity = _value
          item.price = parseInt item.price * parseInt _value
          items.push item

        _data = {
          items: items
          sum: @.sum
        }
        template = Handlebars.compile $('#cart-template').html()
        $('#cart').html template(_data)

        if !@.size()
          $('.cart').addClass 'cart_null'
          $('.cart').removeClass 'cart_active'
          removeBodyScroll()
          createBodyScroll()
        else
          $('.cart').removeClass 'cart_null'


        if !!@.sum
          $('.cart-val').text "#{@.sum} руб."
        else
           $('.cart-val').text ''

      update: (_callback) ->
        str = ''
        sum = 0
        $.each @items, (_key, _value) ->
          item = self.products.getById _key
          if item.id
            if str is ''
              str = "#{_key}:#{_value}"
            else
              str = "#{str};#{_key}:#{_value}"
            sum = sum + parseInt item.price * parseInt _value
        
        @sum = sum
        localStorage.setItem 'cart.items', str

        @render()

        if _callback and typeof _callback is 'function'
          _callback()
    }

    @cart.run() 

  render: (_selector, _template, _data, _callback) ->
    template = Handlebars.compile $(_template).html()
    $(_selector).html template(_data)

    if _callback and typeof _callback is 'function'
      _callback()
    return 

$ ->
  createBodyScroll()
  $('.cart__body').niceScroll
    cursorborder: '0'
    cursorcolor: '#9d9d9d'
    scrollspeed: 100
    mousescrollstep: 25
    cursorwidth: '4px'
    cursorborderradius: '0px'
    oneaxismousemode: false
    cursordragontouch: true
    rtlmode: false
    horizrailenabled: false
    zindex: 7000

  $.getJSON("#{API_URL}/api/get-catalog").done (data)->

    app = new App data

    app.render '#categories', '#categories-template', data, ->
      app.render '#products', '#products-template', data, ->
        $first = $ '.category:first'
        categoryID = $first.data 'id'
        $first.addClass 'category_active'
        $('.product').removeClass 'product_active'
        $("[data-category-id=#{categoryID}]").addClass 'product_active'

    $('body').on 'click', '.category', ->
      $this = $ this
      categoryID = $this.data 'id'
      $('.category').removeClass 'category_active'
      $this.addClass 'category_active'
      $('.product').removeClass 'product_active'
      $("[data-category-id=#{categoryID}]").addClass 'product_active'

    $('body').on 'click', '.btn', ->
      $this = $ this
      id = $this.data 'id'
      if !app.cart.sum
        $('.cart').addClass 'cart_active'
        $('body').addClass 'cart-open'
        removeBodyScroll()
      if app.cart.size() == 1
        setTimeout (->
          $('.cart__icon').animate {
            left: "-40px"
          }, 150
        ), 100

        $('.cart__icon').animate {
          left: "-50px"
        }, 100, ->

      app.cart.add parseInt id
      app.cart.update()

    $('body').on 'click', '.cart__plus', ->
      $this = $ this
      id = $this.data 'id'
      app.cart.add parseInt id
      app.cart.update()
    
    $('body').on 'click', '.cart__minus', ->
      $this = $ this
      id = $this.data('id')
      app.cart.remove parseInt id
      app.cart.update()

    $('body').on 'click', '.cart__clean', ->
      $this = $ this
      id = $this.data('id')
      app.cart.clean parseInt id
      app.cart.update()

  $('.cart__icon').click ->
    if !$('.cart').hasClass 'cart_active'
      $('.cart').addClass 'cart_active'
      $('body').addClass 'cart-open'
      removeBodyScroll()
    else
      $('.cart').removeClass 'cart_active'
      $('body').removeClass 'cart-open'
      createBodyScroll()
    # $('.cart').toggleClass 'cart_active'

  $('.cart__bg').click ->
    $('.cart').removeClass 'cart_active'
    $('body').removeClass 'cart-open'
    createBodyScroll()

  $('.form').validate
    unhighlight: (element, errorClass) ->
      $(element).removeClass 'form__input_error'
    errorPlacement: (error, element) ->
      $(element).addClass 'form__input_error'
    rules:
      'phone': required: true
      'name': required: true
    submitHandler: (form, e) ->
      e.preventDefault()
      $form = $(form)
      str = $form.serialize()
      $.ajax(
        url: '/'
        type: 'post'
        data: str
      ).done ->
    

  # app.render '#categories', '#category-template', data, ->
  #   app.render '#products', '#product-template', data, ->
  #     $first = $ '.category:first'
  #     categoryID = $first.data 'id'
  #     $first.addClass 'category_active'
  #     $('.product').removeClass 'product_active'
  #     $items = $ "[data-category-id=#{categoryID}]"
  #     $items.addClass 'product_active'

  #     app.сart.update ->
  #       if app.сart.getSum() == 0
  #         $('.cart1').text "Пусто"
  #       else 
  #         $('.cart1').text "#{app.сart.getSum()} руб."

  #     $('body').on 'click', '.cart__add', ->
  #       $this = $ this
  #       id = $this.data 'id'
  #       app.сart.add id, ->
  #         if app.сart.getSum() == 0
  #           $('.cart1').text "Пусто"
  #         else 
  #           $('.cart1').text "#{app.сart.getSum()} руб."

  #         dataCart.items = []
  #         dataCart.sum = app.сart.getSum()
  #         $.each app.сart.getItems(), (_key, _value) ->
  #           item = {}
  #           item = app.products.getById _key
  #           item.quantity = _value
  #           item.price = parseInt item.price * parseInt _value
  #           dataCart.items.push item
  #         app.render '#cart', '#cart-template', dataCart, ->

  #     $('body').on 'click', '.category', ->
  #       $this = $ this
  #       categoryID = $this.data 'id'

  #       $('.category').removeClass 'category_active'
  #       $this.addClass 'category_active'

  #       $('.product').removeClass 'product_active'
  #       $items = $ "[data-category-id=#{categoryID}]"
  #       $items.addClass 'product_active'

  #     $('body').on 'click', '.cart__clean', ->
  #       $this = $ this
  #       id = $this.data('id')
  #       app.сart.clean (parseInt id), ->
  #         dataCart.items = []
  #         $.each app.сart.getItems(), (_key, _value) ->
  #           item = app.products.getById _key
  #           item.quantity = _value
  #           item.price = parseInt item.price * parseInt _value
  #           dataCart.items.push item
  #         dataCart.sum = app.сart.getSum()
  #         app.render '#cart', '#cart-template', dataCart
      
  #     dataCart = {        
  #       items: []
  #       sum: app.сart.getSum()
  #     }

  #     $.each app.сart.getItems(), (_key, _value) ->
  #       item = app.products.getById _key
  #       item.quantity = _value
  #       item.price = parseInt item.price * parseInt _value
  #       dataCart.items.push item

  #     app.render '#cart', '#cart-template', dataCart

  #     $('body').on 'click', '.p', ->
  #       $this = $ this
  #       id = $this.parent().data('id')
  #       app.сart.add parseInt id
  #       dataCart.items = []
  #       dataCart.sum = app.сart.getSum()
  #       $.each app.сart.getItems(), (_key, _value) ->
  #         item = {}
  #         item = app.products.getById _key
  #         item.quantity = _value
  #         item.price = parseInt item.price * parseInt _value
  #         dataCart.items.push item
  #       app.render '#cart', '#cart-template', dataCart, ->

  #     $('body').on 'click', '.m', ->
  #       $this = $ this
  #       id = $this.parent().data('id')
  #       app.сart.remove parseInt id
  #       dataCart.items = []
  #       dataCart.sum = app.сart.getSum()
  #       $.each app.сart.getItems(), (_key, _value) ->
  #         item = {}
  #         item = app.products.getById _key
  #         item.quantity = _value
  #         item.price = parseInt item.price * parseInt _value
  #         dataCart.items.push item
  #       app.render '#cart', '#cart-template', dataCart, ->
  #       
  #       
  $(window).scroll (e)->
    # e.preventDefault()