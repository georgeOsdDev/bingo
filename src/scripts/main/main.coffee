"use strict"
require ["jquery","underscore","speakClient","config"],($, u, speakClient, config) ->

  class Bingo
    constructor: ->
      @name = "Bingo"
      @version = "1.0.0"

    getName: ->
      @name

    getVersion: ->
      @version

    chkDependencies:->
      if _ then console.log "underscore #{_.VERSION} is ready"
      if $ then console.log "jquery #{$.prototype.jquery} is ready"
      if config then console.log "config is ready",JSON.stringify(config)
      return _ and $ and config

    # for bingo
    NUMBERS  : []
    RESULTS  : []
    roulette : null
    running  : false

    # access to speak.js
    speak : window.speak

    initialize : (reset) =>
      self = @
      @getFromStorage()
      @resultDisp num for num in @RESULTS
      @el = $("#roulette")

      # set your sound file
      @music = new Audio("audio/sound.mp3")
      @music.loop = true

      if not reset
        $("#start").on "click", (e) ->
          if self.running
            return false
          self.running = true
          self.start()
        $("#stop").on "click", (e) ->
          if not self.running
            return false
          self.running = false
          self.stop()
        $("#reset").on "click", (e) ->
          @rnd =""
          self.stop()
          self.reset()

    start: =>
      if @NUMBERS.length < 1
        @reset()
        return

      self = @
      @music.play()
      @roulette = setInterval ->
        self.rnd = _.shuffle(self.NUMBERS)[0]
        self.el.text self.rnd
      , 100
      # start roulette

    stop: =>
      self = @
      clearInterval @roulette
      @NUMBERS = _.without @NUMBERS, @rnd
      @music.pause()
      @RESULTS.push @rnd
      @resultDisp @rnd
      @saveToStorage()
      setTimeout ->
        @speak.play(self.rnd,{amplitude:1000}) if self.rnd
      , 250
      # @music = new Audio('audio/sound.mp3')

    resultDisp : (num) ->
      $('#result').append "<span class='resultNum'>" + num + ", </span>"  if num

    reset: =>
      $("#result").empty()
      $("#roulette").text("?")
      localStorage.removeItem("Bingo.NUMBERS")
      localStorage.removeItem("Bingo.RESULTS")
      @NUMBERS = []
      @RESULTS = []
      @NUMBERS.push num for num in [1..75]
      @saveToStorage()
      @initialize true

    saveToStorage : =>
      localStorage.setItem "Bingo.NUMBERS", @NUMBERS.join(",")
      localStorage.setItem "Bingo.RESULTS", @RESULTS.join(",")

    getFromStorage :  =>
      numbers = localStorage.getItem("Bingo.NUMBERS")
      if not numbers
        @NUMBERS.push num for num in [1..75]
      else
        @NUMBERS = numbers.split(",")
      results = localStorage.getItem("Bingo.RESULTS") || ""
      @RESULTS = results.split(",")


  bingo = new Bingo
  window.reload() if not bingo.chkDependencies()
  bingo.initialize()

  # export for debug
  window.bingo = bingo
  window.$ = $