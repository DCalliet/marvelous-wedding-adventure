utils = require './utils.coffee'

module.exports =
  outreach:

    text: (invitee) ->
      message = "Hi #{invitee.firstName}! I'm an automated message reaching out on behalf of Sommer Payne and Darius Callet. "
      if invitee.rsvp?
        message += "I see that you have already RSVP'd, great! "
      else
        message += "I see that you have yet to RSVP for the wedding and wanted to send a reminder. "
      message += "Save this number, if you have questions I can provide information. Just reply '?' for some options. "
      return message
    # No need to email people that RSVP'd
    email_no_rsvp: (invitee) ->
      message = "Hi #{invitee.firstName}! I see that you have yet to RSVP for the wedding and wanted to send a reminder! Please visit www.becomingcalliets.com/rsvp "
      if invitee.plusOne is true
        message += "(you have been allotted a plus one). "
      message += "We are looking forward to hearing from you. Sommer Payne and Darius Calliet."
      return message

  genericDisclaimer: () ->
    "Hi, thank you for reaching out to Sommer and Darius' Wedding Messaging Service! You can find more information at www.becomingcalliets.com"
  
  noAction: (invitee) ->
    "Hi #{invitee.firstName}, We are excited to see you at Sommer and Darius' wedding. I am a messaging service designed to help you with any questions you may have.
    For a list of things that I can help with, please respond 'menu'.
    You can find more information at www.becomingcalliet.com"
  
  actions:
    rsvp: (invitee) ->
      if invitee.rsvp?
        message = "Hi #{invitee.firstName}, we already have your RSVP. You're all set!"
        if invitee.plusOne and invitee.rsvp.wantsPlusOne
          message += "Your plus one has been confirmed for the wedding."
        if not invitee.plusOne and invitee.rsvp.wantsPlusOne
          message += "Your plus one has not been yet confirmed for the wedding, Sommer and Darius will reach out if space becomes available"
        return message
      if invitee.plusOne is true
        return "Hi #{invitee.firstName}, Let's confirm your attendance to the wedding. You've been alotted a plus one. Please visit www.becomingcalliets.com/rsvp to let Darius and Sommer know you will be attending."
      else
        return "Hi #{invitee.firstName}, Let's confirm your attendance to the wedding. Please visit www.becomingcalliets.com/rsvp to let Sommer and Darius know you will be attending."
    
    location: (invitee) ->
      "The wedding will be held on August 24 2019 5:00pm at Noah's Event Venue in Memphis, TN. https://goo.gl/maps/yhtBukHgaKD2"
    
    contact: (invitee) ->
      "Hi #{invitee.firstName}, you can get in contact with Darius @ 314-285-9562 and Sommer @ 314-285-9145"
  
    menu: (invitee) ->
      "Here are some responses I understand:\n- rsvp\n- location\n- contact\n- stop"
