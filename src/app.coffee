fs = require 'fs'
koa = require 'koa'
redis = require 'redis'
urls = require './urls'
ngrok = require 'ngrok'
credentials = require '../credentials.json'
bodyParser = require 'koa-bodyparser'
guest = require './guest'

googleapis = require 'googleapis'
google = require './google'

initMiddleware = (app) ->
  # Init Redis Client
  app.context.clients.redis = redis.createClient()

  # Google Sheet Authorization
  authClient = yield google.authorize()
  app.context.clients.sheets = googleapis.google.sheets
    version: 'v4'
  , authClient

  # Guest Book Initialization
  app.context.clients.guestBook = yield guest.populatedGuestBook authClient


# Instantiate server
app = new koa()

# Body Parser
app.use bodyParser()

# Url dispatcher
router = urls()
app.use router.routes()

app.context.clients = {}

module.exports = 
  app:app
  initMiddleware:initMiddleware

