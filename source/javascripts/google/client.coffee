Auth = require "./auth"
Gmail = require "gmail"

class Client
  @installClientJs: (callback) ->
    @_setup_external_handlers callback
    console.debug "-> Installing Google API client script..."
    s = document.createElement "script"
    s.src = "https://apis.google.com/js/client.js?onload=_eg_handle_client_load"
    (document.head || document.documentElement).appendChild s

  @_setup_external_handlers: (callback) ->
    console.debug "-> Setting up the Google API client load handler..."
    window._eg_handle_client_load = ->
      Auth.authImmediateWithCallback true, callback
    window._eg_handle_auth_result = (authResult) ->
      AuthView.handleAuthResult authResult, callback
    window._eg_handle_auth_click = ->
      Auth.authImmediate false
      return false

class AuthView
  AUTH_RESULT_ERR_IMMEDIATE_FAILED = "immediate_failed"
  AUTH_RESULT_ERR_ACCESS_DENIED = "access_denied"

  @displayAuth: ->
    console.log "Displaying modal window..."
    @_gmail_js().tools.add_modal_window "Authorize EmailGrind?",
      "EmailGrind wants to be able to send 'like' messages!",
      -> window._eg_handle_auth_click()

  @handleAuthResult: (authResult, callback) ->
    console.debug "-> Handling authentication result..."
    if authResult && !authResult.error
      console.debug "-> Need to load the Gmail API..."
      @_gmail_js().tools.remove_modal_window()
      if callback then callback()
    else if authResult && authResult.error
      console.warn "There was an error authenticating:", authResult.error
      switch authResult.error
        when AUTH_RESULT_ERR_IMMEDIATE_FAILED then AuthView.displayAuth()
        when AUTH_RESULT_ERR_ACCESS_DENIED then @_gmail_js().tools.remove_modal_window()
    else
      console.error "There was a problem getting the authentication result!"

  # TODO: getter/setter
  # TODO: https://arcturo.github.io/library/coffeescript/03_classes.html
  @_gmail_js: ->
    window._gmail_js ||= new Gmail()

module.exports = Client
