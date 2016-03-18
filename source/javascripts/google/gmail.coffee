# Base64 = require "base64" # TODO: for base64 url safe

class Gmail
  @load: (callback) ->
    console.debug "-> Loading Gmail API..."
    gapi.client.load "gmail", "v1", -> callback()

  @getMessage: (userId, messageId, callback) ->
    request = gapi.client.gmail.users.messages.get
      userId: userId
      id: messageId
    request.execute callback

  @sendMessage: (userId, emailMessage, callback) ->
    console.log "Sending email message:", emailMessage
    # TODO: back to btoa?
    encodedEmail = btoa emailMessage.lines()
    request = gapi.client.gmail.users.messages.send
      userId: userId
      resource:
        raw: encodedEmail
        threadId: emailMessage.threadId
    request.execute callback

module.exports = Gmail
