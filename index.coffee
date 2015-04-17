crel = require 'crel'
selector = require 'dom-select'
text = require 'text-content'
bind = require 'dom-event'
Slider = require './Slider'
require './style.css'

main = ->
  crel document.body,
    crel 'div', id: 'slides', 'class': 'slides',
      crel 'div', 'class': 'slides-item',
        crel 'img', src: 'http://placehold.it/350x150&text=slides+1'
      crel 'div', 'class': 'slides-item',
        crel 'img', src: 'http://placehold.it/350x150&text=slides+2'
      crel 'div', 'class': 'slides-item',
        crel 'img', src: 'http://placehold.it/350x150&text=slides+3'
      crel 'button', 'class': 'slides-prev', 'Prev'
      crel 'button', 'class': 'slides-next', 'Next'
      crel 'button', 'class': 'slides-play', 'Play'
      crel 'button', 'class': 'slides-stop', 'Stop'
    crel 'div', 'Current slide number is ',
      crel 'span', id: 'number'

  items = selector.all '.slides-item'
  prev = selector '.slides-prev'
  next = selector '.slides-next'
  playButton = selector '.slides-play'
  stopButton = selector '.slides-stop'
  span = selector '#number'

  slider = new Slider items

  bind prev, 'click', -> slider.prev() unless slider.isPlaying
  bind next, 'click', -> slider.next() unless slider.isPlaying
  bind playButton, 'click', -> slider.play()
  bind stopButton, 'click', -> slider.stop()

  slider.on 'afterchangeslide', (num) -> text span, "#{num + 1}"
  slider.initialize()

main()
