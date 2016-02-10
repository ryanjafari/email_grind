Request = require "../request"

class Client
  EXTENSION_ID = "ogfeibakfhnfghohmkhdapepgeblocle"
  GMAIL_SCOPES = ['https://www.googleapis.com/auth/gmail.readonly']

  constructor: ->
    console.debug "Constructed client..."
    @_client_id = null
    @_callback = null

  startClient: (callback) ->
    console.debug "Starting client..."
    @_callback = callback
    @_get_client_id_json()

  _get_client_id_json: ->
    console.debug "Sending #{Request.GET_CLIENT_ID_JSON} request..."
    chrome.runtime.sendMessage EXTENSION_ID, {
      type: Request.GET_CLIENT_ID_JSON
      clientIdPath: "client_id.json"
    }, (response) =>
      @_load_client_id_json response

  _load_client_id_json: (json) ->
    console.debug "Loading in the client_id JSON data...", json
    @_client_id = json.web.client_id
    @_setup_external_handlers()

  _setup_external_handlers: ->
    console.debug "Setting up the Google API client load handler..."

    window.handleClientLoad = =>
      console.debug "Handling loading of the Google client library..."
      gapi.auth.authorize {
        client_id: @_client_id
        scope: GMAIL_SCOPES.join(" ")
        immediate: true
      }, @_handle_auth_result

    window.handleAuthClick = ->
      # TODO

    @_install_client_js()

  _handle_auth_result: (authResult) ->
    console.debug "Handling authentication result..."
    # authorizeDiv = document.getElementById "authorize-div"
    if authResult && !authResult.error
      # authorizeDiv.style.display = "none"
      # @_load_gmail_api()
      @_callback()
    else
      console.debug "Need to display the authentication panel!"
      # authorizeDiv.style.display = "inline"

  _install_client_js: ->
    console.debug "Installing Google API client script..."
    s = document.createElement "script"
    s.src = "https://apis.google.com/js/client.js?onload=handleClientLoad"
    (document.head || document.documentElement).appendChild s

module.exports = Client
