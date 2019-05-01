MessagingResponse = require('twilio').twiml.MessagingResponse
guest = require '../guest'
utils = require '../utils'
messages = require '../messages'

module.exports =

  sms: (ctx, next) ->
    body = ctx.request.body
    if not body.From?
      ctx.status = 401
      return
    twiml = new MessagingResponse()
    book = ctx.clients.guestBook

    invitee = await book.find
      phone: utils.normalizePhone body.From
      
    # Unknown incoming phone number
    if not invitee
      twiml.message messages.genericDisclaimer()
      ctx.status = 200
      ctx.type = 'text/xml'
      ctx.body = twiml.toString()
      return
      
    # Command Logic
    keywords = ['menu', 'rsvp', 'location', 'contact', '?']
    msg = body.Body.trim().toLowerCase()
    if not (msg in keywords)
      twiml.message messages.noAction invitee
      ctx.status = 200
      ctx.type = 'text/xml'
      ctx.body = twiml.toString()
      return

    if msg is 'rsvp'
      twiml.message messages.actions.rsvp invitee
      ctx.status = 200
      ctx.type = 'text/xml'
      ctx.body = twiml.toString()
      return
    
    if msg is 'location'
      twiml.message messages.actions.location invitee
      ctx.status = 200
      ctx.type = 'text/xml'
      ctx.body = twiml.toString()
      return
    
    if msg is 'contact'
      twiml.message messages.actions.contact invitee
      ctx.status = 200
      ctx.type = 'text/xml'
      ctx.body = twiml.toString()
      return
    
    if msg is '?'
      twiml.message messages.actions.menu invitee
      ctx.status = 200
      ctx.type = 'text/xml'
      ctx.body = twiml.toString()
      return
    
    if msg is 'menu'
      twiml.message messages.actions.menu invitee
      ctx.status = 200
      ctx.type = 'text/xml'
      ctx.body = twiml.toString()
      return
    
    
    

    
