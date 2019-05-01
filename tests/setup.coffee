_ = require 'lodash'
moment = require 'moment-timezone'
request = require 'supertest'
{ app } = require '../src/app'
credentials = require '../credentials.json'
{ Guest, GuestBook, RSVP } = require '../src/guest'

port = process.env.PORT or 8000
prep = (gb) ->
  gb.app = app
  gb.server = await app.listen port
  authedRequest = request.agent(gb.server)
  guestBook = new GuestBook()

  # Load the guestbook
  guests = [
    new Guest
      phone: credentials.TWILIO_TEST_PHONE_NUMBER['TO']['VALID']
      email: "example1@email.com"
      name: "Dwayne Woodone"
    ,
    new Guest
      phone: credentials.TWILIO_TEST_PHONE_NUMBER['TO']['VALID']
      email: "example2@email.com"
      name: "Brock Twoman"
    ,
    new Guest
      phone: credentials.TWILIO_TEST_PHONE_NUMBER['TO']['VALID']
      email: "example3@email.com"
      name: "Theresa Appletree"
  ]

  guestBook.loadGuests guests

  # Load the RSVPS

  rsvps = _.map guests, (guest, index, guests) ->

    # TODO: Test length of guests to this object
    rsvpExtra = [
      address: "1101 All One Court"
      wantsPlusOne: "No"
      dietaryRestrictions: "fish"
      songRecommendations: "Blow the Whistle"
    ,
      address: undefined
      wantsPlusOne: "Yes"
      dietaryRestrictions: "beef"
      songRecommendations: undefined
    ,
      address: undefined
      wantsPlusOne: "No"
      dietaryRestrictions: undefined
      songRecommendations: "Playa Fly Nobody"
    ][index]
    
    return new RSVP
      submittedOn: moment().format 'MM/DD/YYYY HH:MM:SS'
      name: guest.name
      communicationMethod: _.sample ['Phone Number', 'Email Address']
      email: guest.email
      phone: guest.phone
      address: rsvpExtra.address
      wantsPlusOne: rsvpExtra.wantsPlusOne
      dietaryRestrictions: rsvpExtra.dietaryRestrictions
      songRecommendations: rsvpExtra.songRecommendations

  guestBook.loadRSVPs rsvps
  gb.app.context.clients.guestBook = guestBook
  gb.guestBook = guestBook

  return authedRequest

module.exports = prep