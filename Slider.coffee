{ EventEmitter } = require 'events'
Promise = require 'native-promise-only'
map = require 'lodash/map'
forEach = require 'lodash/foreach'
fade = require 'fade'

module.exports =
class Slider extends EventEmitter
  Object.defineProperties @::,
    isPlaying:
      get: -> !!@_autoPlayID

  constructor: (@items, @opts = {}) ->
    super
    @_fadeSpeed = @opts.fadeSpeed or 300
    @_playSpeed = @opts.playSpeed or 1000
    @_currentNumber = @opts.initialNubmber or 0
    @_autoPlayID = null

  initialize: (num = @_currentNumber) ->
    @_current num
    @_hideAll @items
    @items[@_current()].style.opacity = 1
    @emit 'afterchangeslide', num

  next: ->
    if @_current() is @items.length - 1
      target = 0
    else
      target = @_current() + 1
    @_change target
    @_current target

  prev: ->
    if @_current() is 0
      target = @items.length - 1
    else
      target = @_current() - 1
    @_change target
    @_current target

  play: (speed = @_playSpeed) ->
    return if @isPlaying
    do _play = =>
      @_autoPlayID = setTimeout =>
        @next()
        _play()
      , speed

  stop: ->
    clearTimeout @_autoPlayID
    @_autoPlayID = null

  _current: (num) ->
    return @_currentNumber = num if num?
    return @_currentNumber

  _fadeIn: (el, speed) ->
    new Promise (resolve, reject) ->
      fade.in el, speed, -> resolve el

  _fadeOut: (el, speed) ->
    new Promise (resolve, reject) ->
      fade.out el, speed, -> resolve el

  _change: (num) ->
    if @_current() is num then return
    Promise.resolve()
    .then => @_fadeOutAll @items
    .then => @_fadeIn @items[num], @_fadeSpeed
    .then => @emit 'afterchangeslide', num

  _fadeOutAll: (elements) ->
    Promise.all map elements, (el ,i) =>
      @_fadeOut el, @_fadeSpeed

  _hideAll: (elements) -> forEach elements, (el, i) -> el.style.opacity = 0
