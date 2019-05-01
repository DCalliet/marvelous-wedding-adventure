request = require('supertest')
{ app, initMiddleware } = require '../src/app'
guest = require '../src/guest'
messages = require '../src/messages'
prep = require './setup.coffee'
{ TWILIO_TEST_PHONE_NUMBER } = require '../credentials'
convert = require 'xml-js'

gb = {}
authedRequest =  null

beforeAll () ->
  authedRequest = await prep gb

describe 'Controller', () ->

  it 'should expect a phone number in the request', () ->
    response = await authedRequest.post('/sms')
      .send
        Body: 'Hello'
      .expect 401
    return

  it 'should respond generically to an unknown number', () ->
    phone = TWILIO_TEST_PHONE_NUMBER['FROM']['VALID']
    response = await authedRequest.post('/sms')
      .send
        From: phone
        Body: 'Hello'
      .expect 200
    parsed = convert.xml2js response.text,
      compact: true
    expect(parsed['Response']['Message']['_text']).toEqual messages.genericDisclaimer()
    expect(response.status).toEqual 200
    return

  it 'should respond specifically to an authed person', () ->
    phone = gb.guestBook.guests[0].phone
    guest = gb.guestBook.find
      phone: phone
    response = await authedRequest.post('/sms')
      .send
        From: guest.phone
        Body: 'Hello'
      .expect 200
    parsed = convert.xml2js response.text,
      compact: true
    expect(parsed['Response']['Message']['_text']).toEqual messages.noAction(guest)
    expect(response.status).toEqual 200
    return
  
  it 'should send RSVP information', () ->
    phone = gb.guestBook.guests[0].phone
    guest = gb.guestBook.find
      phone: phone
    response = await authedRequest.post('/sms')
      .send
        From: guest.phone
        Body: 'rsvp'
      .expect 200
    parsed = convert.xml2js response.text,
      compact: true
    expect(parsed['Response']['Message']['_text']).toEqual messages.actions.rsvp(guest)
    expect(response.status).toEqual 200
  
  it 'should send location information', () ->
    phone = gb.guestBook.guests[0].phone
    guest = gb.guestBook.find
      phone: phone
    response = await authedRequest.post('/sms')
      .send
        From: guest.phone
        Body: 'location'
      .expect 200
    parsed = convert.xml2js response.text,
      compact: true
    expect(parsed['Response']['Message']['_text']).toEqual messages.actions.location(guest)
    expect(response.status).toEqual 200
  
  it 'should send contact information', () ->
    phone = gb.guestBook.guests[0].phone
    guest = gb.guestBook.find
      phone: phone
    response = await authedRequest.post('/sms')
      .send
        From: guest.phone
        Body: 'contact'
      .expect 200
    parsed = convert.xml2js response.text,
      compact: true
    expect(parsed['Response']['Message']['_text']).toEqual messages.actions.contact(guest)
    expect(response.status).toEqual 200

  it 'should send menu', () ->
    phone = gb.guestBook.guests[0].phone
    guest = gb.guestBook.find
      phone: phone
    response = await authedRequest.post('/sms')
      .send
        From: guest.phone
        Body: '?'
      .expect 200
    parsed = convert.xml2js response.text,
      compact: true
    expect(parsed['Response']['Message']['_text']).toEqual messages.actions.menu(guest)
    expect(response.status).toEqual 200
    response = await authedRequest.post('/sms')
      .send
        From: guest.phone
        Body: 'menu'
      .expect 200
    parsed = convert.xml2js response.text,
      compact: true
    expect(parsed['Response']['Message']['_text']).toEqual messages.actions.menu(guest)
    



