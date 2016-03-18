Gmail = require "gmail"

class EmailMessage
  constructor: (originalMessage, newContent) ->
    console.debug "-> Constructing email message..."
    @threadId = originalMessage.threadId
    @body = newContent

    # @sender = # TODO: always will be the same sender, current user
    # @recipient = # TODO: will always be whoever is involved to:, see gmail.js
    # @subject = # TODO: can be retrieved using the below for subject...

    # TODO: 1) Rig these up correctly.
    # TODO: 2) Include "In-Reply-To" and "References" from below.
    # TODO: 3) Add quoted body if necessary.

    # for header in originalMessage.payload.headers
    #   name = header.name
    #   value = header.value
    #   switch name
    #     when "Subject" then @subject = value
    #     when "From" then @recipient = value
    #     when "To" then @sender = value
    #

  lines: ->
    console.debug "-> Compiling email message in proper format..."
    emailLines = []
    emailLines.push "From: #{@sender}"
    emailLines.push "To: #{@recipient}"
    emailLines.push "Subject: #{@subject}"
    emailLines.push ""
    emailLines.push @body
    return emailLines.join("\r\n").trim()

module.exports = EmailMessage
