# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
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
  )

$(document).ready(ready)