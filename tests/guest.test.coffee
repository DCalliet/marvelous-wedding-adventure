request = require 'supertest'
guest = require '../src/guest'

describe 'Guest',  () ->
  
  test 'Guest expects contact information', () ->
    data =
      email: null,
      name: 'Riley Freeman'
      phone: null
    expect(() -> return new guest.Guest(data)).toThrow()
  
  test 'Guest should have expected attributes', () ->
    data =
      email: 'example@example.com'
      name: 'Riley Freeman'
      phone: '+15043441956'
    g = new guest.Guest(data)
    expect(g).toBeDefined()
    expect(g.email).toEqual(data.email)
    expect(g.name).toEqual(data.name)
    expect(g.phone).toEqual(data.phone)
    expect(g.firstName).toEqual('Riley')