google = require 'googleapis'
googleAuth = require 'google-auth-library'

class GmailApi
  EXTENSION_ID = "fplokekfnapcahocndgkjckfnadbmjne"
  GMAIL_SCOPES = ['https://www.googleapis.com/auth/gmail.readonly']

  constructor: ->
    @_client_id = null
    @_get_client_id_json()

  handleAuthClick: (event) ->
    gapi.auth.authorize {
      client_id: @_client_id
      scope: GMAIL_SCOPES
      immediate: false
    }, handleAuthResult
    return false

  _authorize:

  _get_client_id_json: ->
    chrome.runtime.sendMessage EXTENSION_ID,
      type: "get_client_id_json", (response) =>
        @_load_client_id_json(response)

  _load_client_id_json: (data) ->
    console.log "Data is: ", data
    json = JSON.parse data
    @_client_id = json.web.client_id

module.exports = GmailApi
