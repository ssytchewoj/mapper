# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  States = {
    IDLE: 1,
    ADDING: 2
  }

  state = States.IDLE
  markers = []

  button_to_idle = ->
    $('#add-marker').text('Добавить метку')
    state = States.IDLE

  button_to_adding = ->
    $('#add-marker').text('Нажмите на карту')
    state = States.ADDING

  update_markers = ->
    handler.removeMarkers(markers)

    uri = 'https://maps.googleapis.com/maps/api/staticmap?size=600x600&markers=|'

    _markers = []
    for row in $("tbody tr:visible")
      marker = {
        lat: $('.lat', row).val()
        lng: $('.lon', row).val()
        infowindow: $('.title', row).val()
      }
      _markers.push(marker)
      uri += marker.lat + ',' + marker.lng + '|'

    markers = handler.addMarkers(_markers)

    if markers.length > 3
      handler.bounds.extendWith(markers)
      handler.fitMapToBounds()
    else
      uri += '&zoom=3'

    $("#link").attr('href', uri)

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
        new_id = new Date().getTime()
        regexp = new RegExp("new_marker", "g")

        new_row = $.parseHTML(marker_row_template.replace(regexp, new_id))

        $('.latlon', new_row).text(e.latLng.lng() + " " + e.latLng.lat())
        $('.lat', new_row).val(e.latLng.lat())
        $('.lon', new_row).val(e.latLng.lng())

        $("tbody").append(new_row)

        update_markers()
        button_to_idle()
    )
    update_markers()
  )

  $('#add-marker').click (e) ->
    switch state
      when States.IDLE
        button_to_adding()
      else
        button_to_idle()

  $('table').click (e) ->
    if $(e.target).hasClass('remove-marker')
      $(e.target).prev('input[type=hidden]').val(1)
      $(e.target).closest('.marker-row').hide()
      update_markers()

$(document).ready(ready)
$(document).on('page:load', ready)