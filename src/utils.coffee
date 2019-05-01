fs = require 'fs'
credentials = require '../credentials.json'
client = require('twilio')(credentials.TWILIO_ACCOUNT_SID, credentials.TWILIO_AUTH_TOKEN)
Q = require 'q'
Phone = require 'phone'
MailComposer = require 'nodemailer/lib/mail-composer'

module.exports =
  sendSMS: Q.denodeify client.messages.create
  
  composeEmail: (opts) ->
    options = {}
    options.from = credentials.EMAIL_FROM
    options.subject = opts.subject
    options.text = opts.text
    if opts.to?
      options.to = opts.to
    if opts.cc?
      options.cc = opts.cc
    if opts.bcc?
      options.bcc = opts.bcc
    mail = new MailComposer options
    return Q.denodeify mail.compile.build

  normalizePhone: (number) ->
    normal = Phone number
    return normal[0] or number
  
  parseYesNo: (value) ->
    if value.trim().toLowerCase() in ['y', 'ye', 'yes']
      return true
    if value.trim().toLowerCase() is ['n', 'no']
      return false
    return 
  
