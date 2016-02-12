class Gmail
  @load: (callback) ->
    console.debug "-> Loading Gmail API..."
    gapi.client.load "gmail", "v1", -> callback()

  @sendMessage: (userId, emailMessage, callback) ->
    console.log "Sending email message:", emailMessage
    encodedEmail = btoa emailMessage.lines()
    request = gapi.client.gmail.users.messages.send
      userId: userId
      resource:
        raw: encodedEmail
    request.execute callback

module.exports = Gmail
