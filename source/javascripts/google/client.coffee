Message = require "../message"
Gmail = require "gmail" # TODO: Too heavy-handed...

class Client
  EXTENSION_ID = "ogfeibakfhnfghohmkhdapepgeblocle"
  GMAIL_SCOPES = ['https://www.googleapis.com/auth/gmail.readonly']

  AUTH_RESULT_ERR_IMMEDIATE_FAILED = "immediate_failed"
  AUTH_RESULT_ERR_ACCESS_DENIED = "access_denied"

  constructor: ->
    console.debug "Constructed Google client..."
    @_client_id = null
    @_callback = null
    @_gmail = new Gmail()

  startClient: (callback) ->
    console.debug "Starting client..."
    @_callback = callback
    @_get_client_id_json()

  _get_client_id_json: ->
    console.debug "Sending message...", "'#{Message.GET_CLIENT_ID_JSON}'"
    chrome.runtime.sendMessage EXTENSION_ID, {
      type: Message.GET_CLIENT_ID_JSON
      clientIdPath: "client_id.json"
    }, (json) =>
      console.debug "=> Received JSON response from extension:", json
      @_load_client_id_json json

  _load_client_id_json: (json) ->
    console.debug "Loading in the client_id JSON data:", json
    @_client_id = json.web.client_id
    @_setup_external_handlers()

  _setup_external_handlers: ->
    console.debug "Setting up the Google API client load handler..."
    window.handleClientLoad = =>
      console.debug "Handling loading of the Google client library..."
      @_authorize true
    @_install_client_js()

  _handle_auth_click: ->
    console.debug "Handling authorization click for the Google client library..."
    @_authorize false
    return false

  _authorize: (immediate) ->
    console.log "Authorizing with Google...", "immediate = #{immediate}"
    gapi.auth.authorize {
      client_id: @_client_id
      scope: GMAIL_SCOPES.join(" ")
      immediate: immediate
    }, @_handle_auth_result

  _handle_auth_result: (authResult) =>
    console.debug "Handling authentication result..."
    if authResult && !authResult.error
      console.debug "Need to load the Gmail API..."
      @_gmail.tools.remove_modal_window()
      @_callback()
    else if authResult && authResult.error
      console.warn "There was an error authenticating:", authResult.error
      switch authResult.error
        when AUTH_RESULT_ERR_IMMEDIATE_FAILED then @_display_auth()
        when AUTH_RESULT_ERR_ACCESS_DENIED then @_gmail.tools.remove_modal_window()
    else
      console.error "There was a problem getting the authentication result!"

  _display_auth: ->
    console.log "Displaying modal window..."
    @_gmail.tools.add_modal_window "Authorize",
      "Authorize access to Gmail API?", => @_handle_auth_click()

  _install_client_js: ->
    console.debug "Installing Google API client script..."
    s = document.createElement "script"
    s.src = "https://apis.google.com/js/client.js?onload=handleClientLoad"
    (document.head || document.documentElement).appendChild s

module.exports = Client
