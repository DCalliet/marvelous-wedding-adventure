_ = require 'lodash'
fs = require 'fs'
path = require 'path'
Papa = require 'papaparse'
csv = require 'csv'
utils = require './utils'
google = require './google'
googleapis = require 'googleapis'
credentials = require '../credentials'

class GuestBook
  constructor: (opts) ->
    @guests = []
    if opts?.guests?
      if not _.every(opts.guest, (guest) -> guest instanceof Guest)
        throw new Error "Must pass in Guest instance!"
      @guests = opts.guests
    @rsvpsByGuest = {}
    @unAuthorizedRSVPS = {}

  loadGuests: (guests) ->
    for guest in guests
      @addGuest guest
  
  loadRSVPs: (rsvps) ->
    for rsvp in rsvps
      if _.findIndex(@guests, (guest) -> guest.name is rsvp.name) is -1
        @unAuthorizedRSVPS[rsvp.name] = rsvp
      else
        @rsvpsByGuest[rsvp.name] = rsvp

  addGuest: (guest) ->
    if not guest instanceof Guest
      throw new Error "Must pass in guest instance!"
    if guest.name in _.map @guests, (guest) -> guest.name
      throw new Error "Guest already exists!"
    @guests.push guest
    return
  
  find: (opts) ->
    if not opts.phone? and not opts.email? and not opts.name?
      throw new Error "Missing required query parameter"
    guest = _.first _.filter @guests, (guest) ->
      match = true
      if opts.phone?
        match = match and (guest.phone is utils.normalizePhone opts.phone)
      if opts.email?
        match = match and (guest.email is opts.email)
      if opts.name?
        match = match and (guest.name is opts.name)
      return match
    if not guest
      return false
    rsvp = null
    for key in Object.keys @rsvpsByGuest
      if guest.name is @rsvpsByGuest[key].name
        rsvp = @rsvpsByGuest[key]
        break
    guest.rsvp = rsvp
    return guest
    
  
class Guest
  constructor: (opts) ->
    if not (opts.phone? or opts.email?)
      throw new Error "Guest Must have a phone or an email"
    @phone = utils.normalizePhone opts.phone
    @email = opts.email
    @name = opts.name
    @firstName = opts.name.split(' ')[0]

class RSVP
  constructor: (opts) ->
    @submittedOn = opts.submittedOn
    @name = opts.name
    @communicationMethod = opts.communicationMethod
    @email = opts.email
    @phone = utils.normalizePhone opts.phone
    @address = opts.address
    @wantsPlusOne = opts.wantsPlusOne
    @dietaryRestrictions = opts.dietaryRestrictions
    @songRecommendations = opts.songRecommendations

module.exports = 
  Guest: Guest
  GuestBook: GuestBook
  RSVP: RSVP
  populatedGuestBook: (authClient) ->
    guestlistId = credentials.GOOGLE_DRIVE_GUESTLIST_ID
    rsvpId = credentials.GOOGLE_DRIVE_RSVP_ID
    rawValues =
      guestlist: []
      rsvp: []

    book = new GuestBook()

    rawValues.guestlist = yield google.getData
      spreadsheetId: guestlistId
      range: 'Sheet3!A1:D'
      auth: authClient
    
    book.loadGuests _.map rawValues.guestlist, (result) ->
      opts = {}
      opts.email = result[0]
      opts.name = result[1]
      opts.phone = result[2]
      opts.plusOne = result[3]

      return new Guest opts

    rawValues.rsvp = yield google.getData
      spreadsheetId: rsvpId
      range: 'Sheet1!A1:I'
      auth: authClient
    
    book.loadRSVPs _.map rawValues.rsvp, (result) ->
      opts = {}
      opts.submittedOn = result[0]
      opts.name = result[1]
      opts.communicationMethod = result[2]
      opts.email = result[3]
      opts.phone = result[4]
      opts.address = result[5]
      opts.wantsPlusOne = result[6]
      opts.dietaryRestrictions = result[7]
      opts.songRecommendations = result[8]

      return new RSVP opts

    return book