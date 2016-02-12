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
      unless authResult._aa
        @_remove_modal_and_notify "Thanks! You're all set with EmailGrind!"
      callback()
    else if authResult && authResult.error
      console.warn "There was an *expected* error authenticating:", authResult.error
      switch authResult.error
        when AUTH_RESULT_ERR_IMMEDIATE_FAILED
          AuthView.displayAuth()
        when AUTH_RESULT_ERR_ACCESS_DENIED
          @_remove_modal_and_notify "No problem. We won't bother you again this session"
    else
      console.error "There was an unexpected error authenticating."

  @_remove_modal_and_notify: (message) ->
    @_gmail_js().tools.remove_modal_window()
    @_gmail_js().tools.infobox message, 10000

  # TODO: getter/setter
  # TODO: https://arcturo.github.io/library/coffeescript/03_classes.html
  @_gmail_js: ->
    window._gmail_js ||= new Gmail()

module.exports = Client
