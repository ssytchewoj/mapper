# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  States = {
    IDLE: 1,
    ADDING: 2
  }

  state = States.IDLE

  button_to_idle = ->
    $('#add-marker').text('Добавить метку')
    state = States.IDLE

  button_to_adding = ->
    $('#add-marker').text('Нажмите на карту')
    state = States.ADDING


  handler = Gmaps.build('Google')
  handler.buildMap({
    provider: {}
    internal:
      id: 'map'
  }, ->
    handler.map.centerOn({
      lat: 50
      lng: 50})
    handler.getMap().setZoom(4)

    google.maps.event.addListener(handler.getMap(), 'click', (e) ->
      if States.ADDING == state
        console.log(e.latLng)

        new_id = new Date().getTime()
        regexp = new RegExp("new_marker", "g")

        new_row = $.parseHTML(marker_row_template.replace(regexp, new_id))

        $('.latlon', new_row).text(e.latLng.lng() + " " + e.latLng.lat())
        $('.lat', new_row).val(e.latLng.lat())
        $('.lon', new_row).val(e.latLng.lng())

        $("tbody").append(new_row)

        button_to_idle()
    )
  )

  $('#add-marker').click (e) ->
    switch state
      when States.IDLE
        button_to_adding()
      else
        button_to_idle()

  $('table').click (e) ->
    console.log e
    if $(e.target).hasClass('remove-marker')
      $(e.target).prev('input[type=hidden]').val(1)
      $(e.target).closest('.marker-row').hide()

$(document).ready(ready)
$(document).on('page:load', ready)