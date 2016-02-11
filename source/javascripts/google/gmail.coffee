class Gmail
  @load: (callback) ->
    console.log "Loading Gmail API..."
    gapi.client.load "gmail", "v1", callback

  @sendMessage: (userId, email, callback) ->
    console.log "Sending email message...", email
    base64EncodedEmail = btoa email
    request = gapi.client.gmail.users.messages.send {
      userId: userId
      message:
        raw: base64EncodedEmail
    }
    request.execute callback

module.exports = Gmail
