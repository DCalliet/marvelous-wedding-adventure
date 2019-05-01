#!/usr/bin/env coffee
{ app , initMiddleware } = require './app'
credentials = require '../credentials'
co = require 'co'
ngrok = require 'ngrok'
minimist = require 'minimist'

port = process.env.PORT or 8000
co ->
  await initMiddleware app
  
  server = app.listen port

  if process.env.NODE_ENV isnt 'production' # ngrok for development
    opts = {}
    opts.addr = port
    if credentials.NGROK_AUTH_TOKEN?
      opts.authToken = credentials.NGROK_AUTH_TOKEN
      opts.subdomain = credentials.NGROK_SUBDOMAIN
    url = await ngrok.connect opts
    console.log "#{url}"

  console.log "Server listening on port #{port}"

.catch (err) ->
  console.log err
  process.exit 1