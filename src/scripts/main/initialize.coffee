"use strict"
require.config
  #urlArgs: "ts="+new Date().getTime()
  baseUrl: "js",
  paths:
    jquery: [
      "http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min",
      "../vendor/jquery/jquery.min"
    ]
    underscore: [
      "../vendor/underscore-amd/underscore-min"
    ]
    speakClient: [
      "../vendor/speak.js/speakClient"
    ]
    config: [
      "config/config"
    ]
