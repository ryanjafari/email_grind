ExtensionMessage = require "../email-grind/extension-message"

class Auth
  EXTENSION_ID = "ogfeibakfhnfghohmkhdapepgeblocle"
  GMAIL_SCOPES = [
    "https://mail.google.com/",
    "https://www.googleapis.com/auth/gmail.compose",
    "https://www.googleapis.com/auth/gmail.modify",
    "https://www.googleapis.com/auth/gmail.send"
  ]

  @authImmediate: (immediate) ->
    @authImmediateWithCallback immediate

  @authImmediateWithCallback: (immediate, callback = null) ->
    @_get_client_id_json => @_authorize(immediate, callback)

  @_authorize: (immediate, callback) ->
    console.log "Authenticating with Google..."
    gapi.auth.authorize {
      client_id: @_client_id()
      scope: GMAIL_SCOPES.join(" ")
      immediate: immediate
    }, (authResult) -> window._eg_handle_auth_result authResult, callback

  @_get_client_id_json: (callback) ->
    if @_client_id()
      console.debug "-> We already have the clientId set:", @_client_id()
      callback()
      return
    else
      console.debug "-> Sending message...", "'#{ExtensionMessage.GET_CLIENT_ID_JSON}'"
      chrome.runtime.sendMessage EXTENSION_ID, {
        type: ExtensionMessage.GET_CLIENT_ID_JSON
        clientIdPath: "client_id.json"
      }, (json) =>
        console.debug "-> Received JSON response from extension:", json
        window.EG_CLIENT_ID = @_load_client_id_json json
        callback()

  @_load_client_id_json: (json) ->
    console.debug "-> Loading in the client_id JSON data:", json
    return json.web.client_id

  # TODO: getter/setter
  # TODO: https://arcturo.github.io/library/coffeescript/03_classes.html
  @_client_id: ->
    window.EG_CLIENT_ID

module.exports = Auth
