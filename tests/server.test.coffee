request = require 'supertest'
app = require '../src/app'

mockListen = jest.fn()
app.listen = mockListen

afterEach () ->
  mockListen.mockReset()

describe 'Server', () ->
  it.skip 'works', (done) ->
    await require '../src/server'
    console.log mockListen.mock.calls
    expect(mockListen.mock.calls.length).toBe 1
    expect(mockListen.mock.calls[0][0]).toBe(process.env.PORT || 3000)
    done()