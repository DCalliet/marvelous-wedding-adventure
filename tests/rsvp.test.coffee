request = require 'supertest'
guest = require '../src/guest'
moment = require 'moment-timezone'

describe 'RSVP', () ->

  test 'RSVP should have expected attributes', () ->
    data =
      submittedOn: moment()
      name: 'Riley Freeman'
      communicationMethod: 'phone'
      email: 'email@example.com'
      phone: '+15043441956'
      address: '1234 Example Lane'
      wantsPlusOne: 'No'
      dietaryRestrictions: ''
      songRecommendations: 'Frany Beverly and Maize'
    rsvp = new guest.RSVP data
    expect(rsvp).toBeDefined()
    expect(rsvp.submittedOn).toEqual(data.submittedOn)
    expect(rsvp.name).toEqual(data.name)
    expect(rsvp.communicationMethod).toEqual(data.communicationMethod)
    expect(rsvp.email).toEqual(data.email)
    expect(rsvp.phone).toEqual(data.phone)
    expect(rsvp.address).toEqual(data.address)
    expect(rsvp.wantsPlusOne).toEqual(data.wantsPlusOne)
    expect(rsvp.dietaryRestrictions).toEqual(data.dietaryRestrictions)
    expect(rsvp.songRecommendations).toEqual(data.songRecommendations)