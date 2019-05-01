router = require 'koa-router'

module.exports = () ->

  urls = router()

  controllers =
    message: require './controllers/message'
  
  urls.all '/sms', controllers.message.sms

  return urls