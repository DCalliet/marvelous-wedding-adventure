fs = require 'fs'
path = require 'path'
readline = require 'readline'
{ google } = require 'googleapis'
credentials = require '../credentials.json'
Q = require 'q'


authorize = () ->
  return new Promise (resolve, reject) ->
    oAuth2Client = new google.auth.OAuth2 credentials.GOOGLE_CLIENT_ID, credentials.GOOGLE_CLIENT_SECRET, credentials.GOOGLE_REDIRECT_URIS[0]
    fs.readFile path.join(__dirname, '../gapitoken.json'), (err, token) ->
      if err
        # get new token
        authUrl = oAuth2Client.generateAuthUrl
          access_type: 'offline'
          scope: credentials.GOOGLE_SCOPES
        console.log authUrl
        rl = readline.createInterface
          input: process.stdin
          output: process.stdout
        rl.question 'Enter the code from that page here: ', (code) ->
          _default  = '4/LQEXQVRADHKp5aUmoWCi9ENFHo5nNYzMjP_0W5hsLCIUptO3PB-q8W0'
          if not code
            console.log 'bleh no code'
          code = _default
          oAuth2Client.getToken code, (err, token) ->
            if err
              reject err
            oAuth2Client.setCredentials token
            fs.writeFile path.join(__dirname, '../gapitoken.json'), JSON.stringify token, (err) ->
              if err
                reject err
            sheets = google.sheets
              version: 'v4'
            , oAuth2Client
            resolve oAuth2Client
      tkn = JSON.parse token
      oAuth2Client.setCredentials tkn
      resolve oAuth2Client

getData = (opts) ->
  return new Promise (resolve, reject) ->
    if not opts.spreadsheetId?
      reject "You must include a spreadsheet id!"
    if not opts.range?
      reject "You must include a range!"
    if not opts.auth?
      reject "You must include the authorization!"
    google.sheets('v4').spreadsheets.values.get
      spreadsheetId: opts.spreadsheetId
      range: opts.range
      auth: opts.auth
    , (err, res) ->
      if err
        reject err.errors
      resolve res.data.values

sendEmail = (opts) ->
  return new Promise (resolve, reject) ->
    if not opts.subject?
      reject "You must include a subject!"
    
    if not opts.text?
      reject "You must include a message body!"
    
    if not opts.to? and not opts.cc? and not opts.bcc?
      reject "You must include one or more recipients!"
    
    if not opts.auth?
      reject "You must include the authorization!"
    
    base64EncodedEmail = yield utils.composeEmail opts

    gmail = google.gmail version: 'v1', opts.auth
    request = gmail.users.message.send
      userId: 'me'
      resource:
        raw: base64EncodedEmail
    resolve request.execute()

module.exports =
  authorize: authorize
  getData: getData
  sendEmail: sendEmail